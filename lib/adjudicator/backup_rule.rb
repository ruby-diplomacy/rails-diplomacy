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
      loop.each_index do |index|
        order = loop[index]
        return false unless Move === order
        
        next_index = (index + 1) % loop.size
        return false unless order.dst = loop[next_index].unit_area
        
        true
      end
    end
    
    def resolve!(loop)
      loop.each do |order|
        order.succeed
      end
    end
  end
  
  RULES = { 
    simple_circular: SimpleCircularMovementRule.new
  }
end
