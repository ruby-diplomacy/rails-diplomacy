require_relative 'orders'

module Diplomacy
  class BackupRule
    @@log = Logger.new( 'adjudicator.log', 'daily' )
    
    def initialize(*rules)
      @rules = []
      rules.each do |rule|
        if RULES.has_key? rule
          @rules << RULES[rule]
        else
          raise "No rule exists for '#{rule}'"
        end
      end
    end
    
    def resolve!(loop)
      @@log.debug "Using backup rule..."
      
      @rules.each do |rule|
        if rule.match(loop)
          rule.resolve!(loop)
          @@log.debug "Used #{rule.class}"
          return
        end
      end
      
      @@log.debug "No rule matched, using All Hold fallback"
      
      # 'All Hold' fallback
      loop.each do |order|
        order.fail
      end
    end
  end
  
  class Rule
    def match(loop)
      raise "This method should be overriden and determine whether a loop matches this rule"
    end
    
    def resolve!(loop)
      raise "This method should be overriden and resolve the orders in the loop"
    end
  end
  
  class SimpleCircularMovementRule < Rule
    def match(loop)
      possible_circular = loop.reject {|order| !(Move === order) }
      return false if possible_circular.size < 2
      
      possible_circular.each_index do |index|
        next_index = (index + 1) % possible_circular.size
        return false unless possible_circular[index].dst == possible_circular[next_index].unit_area
        
        true
      end
    end
    
    def resolve!(loop)
      loop.each do |order|
        order.succeed
      end
    end
  end
  
  class ConvoyParadox < Rule
    # TODO add initialize for alternate rulings
    def match(loop)
      @contested_support = nil
      @disrupting_move = nil
      @convoying_fleet = nil
      @convoyed_move = nil
      loop.each do |order|
        case order.unit.type
        when Unit::ARMY
          if Move === order
            @convoyed_move = order
          end
        when Unit::FLEET
          case order
          when Move
            if @disrupting_move.nil?
              @disrupting_move = order
            else
              return false
            end
          when Support
            if @contested_support.nil?
              @contested_support = order
            else
              return false
            end
          when Convoy
            if @convoying_fleet.nil?
              @convoying_fleet = order
            else
              return false
            end
          end
        end
      end
      
      return false if @contested_support.nil? || @disrupting_move.nil? || @convoying_fleet.nil? || @convoyed_move.nil?
      
      if (@contested_support.src == @disrupting_move.unit_area && @contested_support.dst == @disrupting_move.dst && @disrupting_move.dst == @convoying_fleet.unit_area&& @convoying_fleet.src == @convoyed_move.unit_area && @convoyed_move.dst == @contested_support.unit_area)
        return true
      else
        return false
      end
    end
    
    def resolve!(loop)
      @contested_support.succeed
      @disrupting_move.succeed
      @convoying_fleet.fail
      @convoyed_move.fail
    end
  end
  
  RULES = { 
    simple_circular: SimpleCircularMovementRule.new,
    convoy_paradox: ConvoyParadox.new
  }
end
