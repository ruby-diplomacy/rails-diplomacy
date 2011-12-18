require 'logger'

require_relative 'orders'
require_relative 'state'
require_relative '../graph/graph'

module Diplomacy
  class Adjudicator
    @@log = Logger.new( 'adjudicator.log', 'daily' )
    
    attr_accessor :moves_by_dst
    attr_accessor :moves_by_origin
    attr_accessor :supports_by_dst
    attr_accessor :supports_by_origin
    attr_accessor :holds
    attr_accessor :convoys
    attr_accessor :state
    
    def initialize(map)
      @map = map
    end

    def validate_orders(state, orders)
      puts 'FIXME: VALIDATE ORDERS'
      true
    end

    def resolve(state, orders)
      return unless validate_orders(state, orders)
      
      @state = state
      @moves_by_dst = {}
      @moves_by_origin = {}
      @supports_by_dst = {}
      @supports_by_origin = {}
      @support_holds = {}
      @holds = {}
      @convoys = {}
      
      results = {}
      new_state = GameState.new
      wrapped_orders = []
      
      # create wrappers and categorize orders
      orders.each do |order|
        wrapped = OrderWrapper.new(order)
        
        case wrapped.order
        when Move
          (self.moves_by_dst[wrapped.order.dst] ||= Array.new) << wrapped
          self.moves_by_origin[wrapped.order.unit_area] = wrapped
        when Support
          (self.supports_by_dst[wrapped.order.dst] ||= Array.new) << wrapped
          self.supports_by_origin[wrapped.order.unit_area] = wrapped
        when Hold 
          (self.holds[wrapped.order.dst] ||= Array.new) << wrapped
        when SupportHold
          (self.supports_by_dst[wrapped.order.dst] ||= Array.new) << wrapped
          self.supports_by_origin[wrapped.order.dst] = wrapped
        when Convoy
          (self.convoys[wrapped.order.dst] ||= Array.new) << wrapped
        end
        wrapped_orders << wrapped
      end
      
      wrapped_orders.each do |order|
        resolve_order(order)
      end
      
      return new_state,wrapped_orders
    end
    
    def resolve_order(wrapped_order)
      if not wrapped_order.unresolved?
        return
      end
      
      dependencies = get_dependencies(wrapped_order)
      
      dependencies.each do |dependency|
        resolve_order(dependency) # TODO avoid infinite loops
      end
      
      # sets order status
      adjudicate(wrapped_order, dependencies)
      @@log.debug "Decided: #{wrapped_order.status}"
    end
    
    def get_dependencies(wrapped_order)
      dependencies = []
      order = wrapped_order.order
      case order
      when Move
        # get all convoys for this move
        convoys_to_area = @convoys[order.dst]
        convoys_to_area.each do |convoy|
          if convoy.order.src == order.unit_area
            dependencies << convoy
          end
        end unless convoys_to_area.nil?
        
        # get all moves to the same destination
        some_deps = @moves_by_dst[order.dst]
        
        if not some_deps.nil?
          dependencies.concat(some_deps.reject {|dep| dep.equal? wrapped_order})
        end
        
        # get all supports to the destination
        some_deps = @supports_by_dst[order.dst]
        
        if not some_deps.nil?
          dependencies.concat(some_deps.reject {|dep| dep.equal? wrapped_order})
        end
        
        # get the move leaving from the destination - can only be one or zero
        dep_move = @moves_by_origin[order.dst]
        
        # add the move from the destination, unless it's a head to head 
        dependencies << dep_move unless dep_move.nil? or dep_move.order.dst == order.unit_area
      when Support, SupportHold
        # get all moves towards this area
        moves_to_area = @moves_by_dst[order.unit_area]
        
        # get related convoy orders
        related_convoys = []
        
        moves_to_area.each do |wrapped_move|
          # get all convoys for this move
          convoys_to_area = @convoys[wrapped_move.order.dst]
          convoys_to_area.each do |convoy|
            if convoy.order.src == wrapped_move.order.src
              related_convoys << convoy
            end
          end unless convoys_to_area.nil?
        end unless moves_to_area.nil?
        
        dependencies.concat(related_convoys)
      when Hold
        # intentionally empty: Holds have no dependencies
      when Convoy
        deps_part = @moves_by_dst[order.unit_area]
        dependencies.concat(deps_part) unless deps_part.nil?
      end
      
      @@log.debug "Dependencies for #{wrapped_order} are #{dependencies}"
      
      dependencies
    end
    
    def adjudicate(wrapped_order, dependencies)
      @@log.debug "Adjudicating #{wrapped_order.order}"
      
      order = wrapped_order.order
      case order
      when Move
        # check convoy path
        related_convoys = @convoys[order.dst]
        if not related_convoys.nil?
          related_convoys.delete_if {|move| not move.order.src.eql? order.unit_area}
        end
        
        # this checks if ANY convoy fails, which isn't enough for eg. multiple 
        # convoy paths. Need to seperate into paths and check each one. 
        related_convoys.each do |convoy|
          if convoy.status == OrderWrapper::FAILURE
            wrapped_order.status = OrderWrapper::FAILURE
            return
          end
        end unless related_convoys.nil?
        
        # check for head to head battle
        head_to_head_move = nil
        
        dst_move = @moves_by_origin[order.dst]
        head_to_head_move = dst_move if (not dst_move.nil?) and dst_move.order.dst == order.unit_area
        
        attack_strength = calculate_attack_strength(wrapped_order)
        
        @@log.debug "Has attack strength #{attack_strength}"
        
        if not head_to_head_move.nil?
          # there is a head to head battle
          defend_prevent_strengths = [calculate_defend_strength(head_to_head_move)]
          if not (competing_moves = @moves_by_dst[order.dst].reject {|move| move.equal? wrapped_order}).nil?
            competing_moves.each do |competing_move|
              defend_prevent_strengths << calculate_prevent_strength(competing_move)
            end
          end
          
          defend_prevent_strengths.sort!
          
          attack_strength > defend_prevent_strengths[-1] ? 
            wrapped_order.status = OrderWrapper::SUCCESS 
          : wrapped_order.status = OrderWrapper::FAILURE
            
        else
          # there is no head to head battle
          hold_strength = calculate_hold_strength(order.dst)
          @@log.debug "Hold strength for #{order.dst}: #{hold_strength}"
          hold_prevent_strengths = [hold_strength]
          if not (competing_moves = @moves_by_dst[order.dst].reject {|move| move.equal? wrapped_order}).nil?
            competing_moves.each do |competing_move|
              hold_prevent_strengths << calculate_prevent_strength(competing_move)
            end
          end
          
          hold_prevent_strengths.sort!
          
          @@log.debug "#{attack_strength}, #{hold_prevent_strengths}"
          
          attack_strength > hold_prevent_strengths[-1] ? 
            wrapped_order.status = OrderWrapper::SUCCESS 
          : wrapped_order.status = OrderWrapper::FAILURE
        end
        
      when Support        
        # get all moves against this area
        moves_to_area = @moves_by_dst[order.unit_area]
        
        moves_to_area.each do |wrapped_move|
          if order.nationality != wrapped_move.order.nationality and
              wrapped_move.order.unit_area != order.dst
            wrapped_order.status = OrderWrapper::FAILURE
            return 
          end
        end unless moves_to_area.nil?
          
        # no moves have cut this support, so it succeeds
        wrapped_order.status = OrderWrapper::SUCCESS
        
      when Hold
        # Hold always succeeds
        wrapped_order.status = OrderWrapper::SUCCESS
      when Convoy
        intercepting_moves = @moves_by_dst[order.unit_area]
        
        intercepting_moves.each do |move|
          if move.status == OrderWrapper::SUCCESS
            wrapped_order.status = OrderWrapper::FAILURE
            return
          end
        end unless intercepting_moves.nil?
        
        wrapped_order.status = OrderWrapper::SUCCESS
      end
    end
    
    def calculate_attack_strength(wrapped_move)
      strength = 1
      
      unit_at_dst = @state.area_unit(wrapped_move.order.dst)
      
      # use this to determine if unit leaving - can only be zero or one
      dst_move = @moves_by_origin[wrapped_move.order.dst]
      
      if unit_at_dst != nil and (not dst_move.nil?) and dst_move.status != OrderWrapper::SUCCESS
        if unit_at_dst.nationality == wrapped_move.order.nationality
          return 0 # no friendly fire in this game
        else
          supports = @supports_by_dst[wrapped_move.order.dst]
          
          supports.each do |support|
            if support.order.src == wrapped_move.order.unit_area and 
                support.order.nationality != unit_at_dst.nationality and 
                support.status == OrderWrapper::SUCCESS 
              strength += 1
            end
          end unless supports.nil?
          
        end
      else # destination is empty or the unit at the destination successfully moves away
        supports = @supports_by_dst[wrapped_move.order.dst]
        
        supports.each do |support|
          if support.order.src == wrapped_move.order.unit_area and 
              support.status == OrderWrapper::SUCCESS 
            strength += 1
          end
        end unless supports.nil?
      end
      
      return strength
    end
    
    def calculate_defend_strength(wrapped_move)
      strength = 1
      supports = @supports_by_dst[wrapped_move.order.dst]
      
      supports.each do |support|
        if support.order.src == wrapped_move.order.unit_area and 
            support.status == OrderWrapper::SUCCESS 
          strength += 1
        end
      end unless supports.nil?
      
      return strength
    end
    
    def calculate_prevent_strength(wrapped_move)
      
      # TODO path
      
      strength = 1
      supports = @supports_by_dst[wrapped_move.order.dst]
      
      # FIXME some ambiguity regarding prevent strength and defend strength
      supports.each do |support|
        if support.order.src == wrapped_move.order.unit_area and 
            support.status == OrderWrapper::SUCCESS 
          strength += 1
        end
      end unless supports.nil?
      
      return strength
    end
    
    def calculate_hold_strength(area)
      if not (unit_at_dst = @state.area_unit(area)).nil?
        # use this to determine if unit leaving
        dst_move = @moves_by_origin[area]
        
        if (not dst_move.nil?) # unit was ordered to move
          strength = 0 if dst_move.status != OrderWrapper::SUCCESS
          strength = 1 if dst_move.status != OrderWrapper::FAILURE
        else # unit was ordered something supportable
          strength = 1
          
          supports = @holds[area]
          
          supports.each do |support|
            if support.status == OrderWrapper::SUCCESS 
              strength += 1
            end
          end unless supports.nil?
        end
      else # there is no unit
        strength = 0
      end
      
      return strength
    end
  end
end
