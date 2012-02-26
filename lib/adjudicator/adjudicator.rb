require 'logger'

require_relative 'orders'
require_relative 'state'
require_relative 'backup_rule'
require_relative '../graph/graph'

module Diplomacy
  class Validator
    @@log = Logger.new( 'adjudicator.log', 'daily' )
    
    def initialize(state, map, order_list)
      @state = state
      @map = map
      @orders = OrderCollection.new(order_list)
      @invalid_orders = []
    end
    
    def validate_orders
      @orders.each do |order|
        order.fail unless valid_order?(order)
        @@log.debug "Decided: #{order.status_readable}"
      end
      sanitized_orders = @orders.orders.collect {|order| order.resolved? ? Hold.new(order.unit, order.unit_area) : order}
      invalid_orders = @orders.orders.collect {|order| order.resolved? ? order : nil }
      
      return OrderCollection.new(sanitized_orders), invalid_orders
    end
    
    def valid_order?(order)
      @@log.debug "Validating #{order}"
      case order
      when Move
        # can't move to own space
        return false if order.dst.eql? order.unit_area
        
        # if sea unit, can't be convoyed, move must be valid
        return false if order.unit.is_fleet? && (not valid_move?(order))
        
        # if land unit, invalid move might be part of a convoy
        if order.unit.is_army? && !valid_move?(order) && @orders.convoys_for_move(order).empty?
          return false
        end
      when Support
        return false unless valid_move?(order) # works fine for support validity, too
        
        # check whether supported move is valid, as well
        m = @orders.supported_move(order)
        return false unless valid_order?(m)
      when Convoy
        # if in coastal area, fail
        return false unless @map.areas[order.unit_area].borders[Area::LAND_BORDER].empty?
        
        m = Move.new(@state[order.src].unit, order.src, order.dst)
        m.unit_area_coast = order.src_coast
        m.dst_coast = order.dst_coast
        return false unless valid_order?(m)
      end
      true
    end
    
    def valid_move?(move)
      if move.unit.is_army? && @map.neighbours?(move.unit_area, move.dst, Area::LAND_BORDER)
        return true
      elsif move.unit.is_fleet?
        # yuck - but it gets the job done
        move.unit_area_coast.nil? ? from = move.unit_area : from = (move.unit_area.to_s + move.unit_area_coast.to_s).to_sym
        move.dst_coast.nil? ? to = move.dst : to = (move.dst.to_s + move.dst_coast.to_s).to_sym
        
        return true if @map.neighbours?(from, to, Area::SEA_BORDER)
      else
        return false
      end
    end
  end
  
  class Adjudicator
    @@log = Logger.new( 'adjudicator.log', 'daily' )
    
    attr_accessor :orders
    attr_accessor :map
    
    def initialize(map, backup_rule=nil)
      @map = map
      if backup_rule
        @backup_rule = backup_rule
      else
        @backup_rule = BackupRule.new(:simple_circular)
      end
    end

    def resolve!(state, unchecked_orders)
      validator = Validator.new(state, @map, unchecked_orders)
      @orders,invalid_orders = validator.validate_orders
      
      @state = state
      @loop_detector = []
      
      @orders.each do |order|
        resolve_order!(order)
      end
      
      new_state = GameState.new
      
      reconcile!(@orders.orders, invalid_orders)
      
      return new_state,@orders.orders
    end
    
    def resolve_order!(order)
      if order.resolved?
        @@log.debug "#{order} already resolved: #{order.status_readable}"
        return
      end
      
      unless @loop_detector.member?(order)
        @loop_detector << order
      else
        @@log.debug("Loop detected: #{@loop_detector}")
        
        loop = Array.new(@loop_detector)
        @loop_detector = []
        
        unless guess_resolve!(loop)
          @backup_rule.resolve!(loop)
        end
        return
      end
      
      dependencies = get_dependencies(order)
      
      dependencies.each do |dependency|
        resolve_order!(dependency)
      end
      
      @loop_detector.delete(order)
      
      # sets order status
      adjudicate!(order)
      @@log.debug "Decided: #{order.status_readable}"
    end
    
    def get_dependencies(order)
      dependencies = []
      case order
      when Move
        # get all convoys for this move
        dependencies.concat(@orders.convoys_for_move(order))
        
        # get all moves to the same destination
        some_deps = @orders.moves_by_dst(order.dst, skip_me=true, me=order)
        
        # get all supports to the destination
        dependencies.concat(@orders.supports_by_dst(order.dst))
        
        # get all support holds to the destination
        dependencies.concat(@orders.supportholds_to(order.dst))
        
        # get the move leaving from the destination - can only be one or zero
        dep_move = @orders.moves_by_origin(order.dst)
        
        # add the move from the destination, unless it's a head to head 
        dependencies << dep_move unless dep_move.nil? or dep_move.dst == order.unit_area
      when Support, SupportHold
        # get all moves towards this area
        moves_to_area = @orders.moves_by_dst(order.unit_area)
        
        # get related convoy orders - these are the true dependencies
        moves_to_area.each do |move|
          # get all convoys for this move
          dependencies.concat(@orders.convoys_for_move(move))
        end
      when Hold
        # intentionally empty: Holds have no dependencies
      when Convoy
        dependencies.concat(@orders.moves_by_dst(order.unit_area)) 
      end
      
      @@log.debug "Dependencies for #{order} are #{dependencies}"
      
      dependencies
    end
    
    def adjudicate!(order)
      if order.resolved?
        @@log.debug "#{order} already resolved: #{order.status_readable}"
        return
      end
      @@log.debug "Adjudicating #{order}"
      
      case order
      when Move        
        # check for head to head battle
        head_to_head_move = nil
        
        dst_move = @orders.moves_by_origin(order.dst)
        head_to_head_move = dst_move if (not dst_move.nil?) and dst_move.dst == order.unit_area
        
        attack_strength = calculate_attack_strength(order)
        
        @@log.debug "Has attack strength #{attack_strength}"
        
        if not head_to_head_move.nil?
          # there is a head to head battle
          defend_prevent_strengths = [calculate_defend_strength(head_to_head_move)]
          if not (competing_moves = @orders.moves_by_dst(order.dst).reject {|move| move.equal? order}).nil?
            competing_moves.each do |competing_move|
              defend_prevent_strengths << calculate_prevent_strength(competing_move)
            end
          end
          
          defend_prevent_strengths.sort!
          
          attack_strength > defend_prevent_strengths[-1] ? 
            order.succeed : order.fail
            
        else
          # there is no head to head battle
          hold_strength = calculate_hold_strength(order.dst)
          @@log.debug "Hold strength for #{order.dst}: #{hold_strength}"
          hold_prevent_strengths = [hold_strength]
          # competing moves
          @orders.moves_by_dst(order.dst, skip_me=true, me=order).each do |competing_move|
            hold_prevent_strengths << calculate_prevent_strength(competing_move)
          end
          
          hold_prevent_strengths.sort!
          
          @@log.debug "#{attack_strength}, #{hold_prevent_strengths}"
          
          attack_strength > hold_prevent_strengths[-1] ? 
            order.succeed : order.fail
        end
        
      when Support, SupportHold
        # get all moves against this area
        moves_to_area = @orders.moves_by_dst(order.unit_area)
        
        moves_to_area.each do |move|
          if order.nationality != move.nationality &&
              move.unit_area != order.dst && check_path(move)
            order.fail
            return 
          end
        end
          
        # no moves have cut this support, so it succeeds (with exception below)
        order.succeed
        
        if SupportHold === order 
          # support holds fail if the supported unit moves
          order.fail if not @orders.moves_by_origin(order.dst).nil?
        else # Support === order
          supported_move = @orders.moves_by_origin(order.src)
          
          # supports fail if there is no such move, or if the move of the 
          # unit in the target area moves elsewhere
          if supported_move == nil or not supported_move.dst.eql? order.dst
            order.fail
          end
        end
      when Hold
        # Hold always succeeds
        order.succeed
      when Convoy
        intercepting_moves = @orders.moves_by_dst(order.unit_area)
        
        intercepting_moves.each do |move|
          if move.succeeded?
            order.fail
            return
          end
        end
        
        if @orders.convoyed_move(order).nil?
          order.fail
          return
        end
        
        order.succeed
      end
      
      @@log.debug "Decision: #{order.resolution_readable}"
    end
    
    def check_path(move)
      return true if @map.neighbours? move.unit_area, move.dst, Area::LAND_BORDER or @map.neighbours? move.unit_area, move.dst, Area::SEA_BORDER
      
      # check convoy path
      related_convoys = @orders.convoys_for_move(move)
      
      @@log.debug "related convoys: #{related_convoys}"
      
      successful_convoys = related_convoys.reject {|convoy| convoy.failed?}
      
      # see if remaining convoy orders form a path
      check_path_recursive(move, successful_convoys, [move.unit_area])
    end
    
    def check_path_recursive(move, unused_convoys, last_reached_areas)
      @@log.debug "unused_convoys: #{unused_convoys}, last_reached_areas: #{last_reached_areas}"
      
      last_reached_areas.each do |area|
        # if we have reached some area bordering the target area, there is a valid path
        return true if @map.neighbours?(area, move.dst, Area::SEA_BORDER)
      end
      
      return false if unused_convoys.empty?
      
      next_reached_areas = []
      
      last_reached_areas.each do |area|
        # collect all convoy areas that border the last reached areas
        # delete the corresponding convoys
        unused_convoys.each do |convoy|
          neighbours = @map.neighbours?(area, convoy.unit_area, Area::SEA_BORDER)
          @@log.debug "neighbours: #{convoy.unit_area}, #{area}, #{neighbours}"
          if @map.neighbours?(area, convoy.unit_area, Area::SEA_BORDER) and (not next_reached_areas.member? convoy.unit_area)
            next_reached_areas << convoy.unit_area
            unused_convoys.delete(convoy)
          end
        end
      end
      
      @@log.debug "next_reached_areas: #{next_reached_areas}"
      
      # areas in next_reached_areas might not be unique
      next_reached_areas.uniq!
      
      # if we reached no new areas, fail
      return false if next_reached_areas.empty?
      
      check_path_recursive(move, unused_convoys, next_reached_areas)
    end
    
    def calculate_attack_strength(move)
      # if the move path is not successful, strength is 0
      return 0 unless check_path(move)
      
      strength = 1
      
      unit_at_dst = @state.area_unit(move.dst)
      
      # use this to determine if unit leaving - can only be zero or one
      dst_move = @orders.moves_by_origin(move.dst)
      
      if unit_at_dst == nil or ( (not dst_move.nil?) and dst_move.succeeded? )
        # destination is empty or the unit at the destination successfully moves away
        supports = @orders.supports_by_dst(move.dst)
        
        supports.each do |support|
          if support.src == move.unit_area and 
              support.succeeded?
            strength += 1
          end
        end
      else
        # destination is not empty and didn't move away
        if unit_at_dst.nationality == move.nationality
          return 0 # no friendly fire in this game
        else
          supports = @orders.supports_by_dst(move.dst)
          
          supports.each do |support|
            if support.src == move.unit_area and 
                support.nationality != unit_at_dst.nationality and 
                support.succeeded?
              strength += 1
            end
          end
        end
      end
      
      return strength
    end
    
    def calculate_defend_strength(move)
      strength = 1
      supports = @orders.supports_by_dst(move.dst)
      
      supports.each do |support|
        if support.src == move.unit_area and 
            support.succeeded?
          strength += 1
        end
      end
      
      return strength
    end
    
    def calculate_prevent_strength(move)
      # if the move path is not successful, strength is 0
      return 0 unless check_path(move)
      
      strength = 1
      supports = @orders.supports_by_dst(move.dst)
      
      # FIXME some ambiguity regarding prevent strength and defend strength
      supports.each do |support|
        if support.src == move.unit_area and 
            support.succeeded?
          strength += 1
        end
      end
      
      return strength
    end
    
    def calculate_hold_strength(area)
      if not (unit_at_dst = @state.area_unit(area)).nil?
        # use this to determine if unit leaving
        dst_move = @orders.moves_by_origin(area)
        
        if (not dst_move.nil?) # unit was ordered to move
          strength = 0 if dst_move.succeeded?
          strength = 1 if dst_move.failed?
        else # unit was ordered something supportable
          strength = 1
          
          supports = @orders.supportholds_to(area)
          
          supports.each do |support|
            strength += 1 if support.succeeded?
          end
        end
      else # there is no unit
        strength = 0
      end
      
      return strength
    end
    
    def guess_resolve!(loop)
      @@log.debug "Entered guess_resolve! for loop: #{loop}"
      return if loop.empty?
      
      resolutions = []
      
      head = loop[0]
      tail = loop[1..-1].reverse
      
      # guess negative for head
      head.guess(Diplomacy::FAILURE)
      tail.each do |order|
        adjudicate!(order)
      end
      
      head.unresolve
      adjudicate!(head)
      
      @@log.debug tail.collect { |order| order.status_readable }
      
      resolutions << head.resolution
      
      # now clear and guess positive
      clear_orders!(tail)
      
      head.guess(Diplomacy::SUCCESS)
      tail.each do |order|
        adjudicate!(order)
      end
      
      head.unresolve
      adjudicate!(head)
      
      @@log.debug tail.collect { |order| order.to_s }
      
      resolutions << head.resolution
      
      @@log.debug "Guess resolutions: #{resolutions}"
      
      clear_orders!(tail)
      
      if (consistent = resolutions[0] == resolutions[2])
        head.resolution = resolutions[0]
        head.resolve
        
        # hm. might be better to store them
        tail.each do |order|
          adjudicate!(order)
        end
      end
      
      consistent
    end
    
    def clear_orders!(orders)
      orders.each do |order|
        order.unresolve
      end
    end
    
    def reconcile!(resolved_orders, invalid_orders)
      resolved_orders.each_index do |index|
        resolved_orders[index] = invalid_orders[index] if invalid_orders[index]
      end
    end
  end
end
