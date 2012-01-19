require 'logger'

require_relative 'orders'
require_relative 'state'
require_relative '../graph/graph'

module Diplomacy
  class OrderCollection
    attr_accessor :orders
    attr_accessor :moves
    attr_accessor :supports
    attr_accessor :supportholds
    attr_accessor :holds
    attr_accessor :convoys
    
    def initialize(orders)
      @orders = []
      @moves = {}
      @supports = {}
      @holds = {}
      @supportholds = {}
      @convoys = {}
      
      # create wrappers and categorize orders
      orders.each do |order|
        case order
        when Move
          (self.moves[order.dst] ||= Array.new) << order
        when Support
          (self.supports[order.dst] ||= Array.new) << order
        when Hold 
          (self.holds[order.dst] ||= Array.new) << order
        when SupportHold
          (self.supportholds[order.dst] ||= Array.new) << order
        when Convoy
          (self.convoys[order.dst] ||= Array.new) << order
        end
        @orders << order
      end
    end
    
    def each(&blk)
      @orders.each(&blk)
    end
    
    def convoys_for_move(move)
      convoys_to_area = @convoys[move.dst]
      if convoys_to_area.nil?
        return []
      end
      
      return convoys_to_area.find_all { |convoy| convoy.src.eql? move.unit_area }
    end
    
    def moves_by_dst(area, skip_me=false, me=nil)
      moves = @moves[area] || []
      
      if skip_me
        moves.reject {|move| move.equal? me}
      else
        moves
      end
    end
    
    def supports_by_dst(area)
      supports = @supports[area] || []
    end
    
    def moves_by_origin(area)
      @moves.values.each do |moves_for_area|
        # only one at most can exist, so detect is enough
        if not (ret = moves_for_area.detect { |move| move.unit_area.eql? area }).nil?
          return ret
        end
      end
      
      # no compyling move was found, return nil
      return nil
    end
    
    def hold_in(area)
      hold = @holds[area] || []
    end
    
    def supportholds_to(area)
      supports = @supportholds[area] || []
    end
  end
  
  class Adjudicator
    @@log = Logger.new( 'adjudicator.log', 'daily' )
    
    attr_accessor :orders
    attr_accessor :map
    
    def initialize(map)
      @map = map
    end

    def validate_orders!(state, orders)
      puts 'FIXME: VALIDATE ORDERS'
      true
    end

    def resolve!(state, orders)
      return unless validate_orders!(state, orders)
      
      @state = state
      
      @orders = OrderCollection.new(orders)
      
      @orders.each do |order|
        resolve_order!(order)
      end
      
      new_state = GameState.new
      
      return new_state,@orders.orders
    end
    
    def resolve_order!(order)
      if not order.unresolved?
        return
      end
      
      dependencies = get_dependencies(order)
      
      dependencies.each do |dependency|
        resolve_order!(dependency) # TODO avoid infinite loops
      end
      
      # sets order status
      adjudicate!(order, dependencies)
      @@log.debug "Decided: #{order.status}"
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
    
    def adjudicate!(order, dependencies)
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
            order.status = SUCCESS 
          : order.status = FAILURE
            
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
            order.status = SUCCESS 
          : order.status = FAILURE
        end
        
      when Support, SupportHold
        # get all moves against this area
        moves_to_area = @orders.moves_by_dst(order.unit_area)
        
        moves_to_area.each do |move|
          if order.nationality != move.nationality and
              move.unit_area != order.dst
            order.status = FAILURE
            return 
          end
        end
          
        # no moves have cut this support, so it succeeds (with exception below)
        order.status = SUCCESS
        
        if SupportHold === order 
          # support holds fail if the supported unit moves
          order.status = FAILURE if not @orders.moves_by_origin(order.dst).nil?
        else # Support === order
          supported_move = @orders.moves_by_origin(order.src)
          
          # supports fail if there is no such move, or if the move of the 
          # unit in the target area moves elsewhere
          if supported_move == nil or not supported_move.dst.eql? order.dst
            order.status = FAILURE
          end
        end
      when Hold
        # Hold always succeeds
        order.status = SUCCESS
      when Convoy
        intercepting_moves = @orders.moves_by_dst(order.unit_area)
        
        intercepting_moves.each do |move|
          if move.status == SUCCESS
            order.status = FAILURE
            return
          end
        end
        
        order.status = SUCCESS
      end
    end
    
    def check_path(move)
      return true if @map.neighbours? move.unit_area, move.dst, Area::LAND_BORDER or @map.neighbours? move.unit_area, move.dst, Area::SEA_BORDER
      
      # check convoy path
      related_convoys = @orders.convoys_for_move(move)
      
      @@log.debug "related convoys: #{related_convoys}"
      
      successful_convoys = related_convoys.reject {|convoy| convoy.status.eql? FAILURE}
      
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
      
      check_path_recursive(move, unused_convoys, next_reached_areas)
    end
    
    def calculate_attack_strength(move)
      # if the move path is not successful, strength is 0
      return 0 unless check_path(move)
      
      strength = 1
      
      unit_at_dst = @state.area_unit(move.dst)
      
      # use this to determine if unit leaving - can only be zero or one
      dst_move = @orders.moves_by_origin(move.dst)
      
      if unit_at_dst == nil or ( (not dst_move.nil?) and dst_move.status == SUCCESS )
        # destination is empty or the unit at the destination successfully moves away
        supports = @orders.supports_by_dst(move.dst)
        
        supports.each do |support|
          if support.src == move.unit_area and 
              support.status == SUCCESS 
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
                support.status == SUCCESS 
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
            support.status == SUCCESS 
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
            support.status == SUCCESS 
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
          strength = 0 if dst_move.status != SUCCESS
          strength = 1 if dst_move.status != FAILURE
        else # unit was ordered something supportable
          strength = 1
          
          supports = @orders.supportholds_to(area)
          
          supports.each do |support|
            strength += 1 if support.status == SUCCESS 
          end
        end
      else # there is no unit
        strength = 0
      end
      
      return strength
    end
  end
end
