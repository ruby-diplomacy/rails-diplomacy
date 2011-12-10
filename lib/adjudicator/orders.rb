require 'logger'

require_relative 'state'
require_relative '../graph/graph'

module Diplomacy 

  class GenericOrder
    attr_accessor :unit, :unit_area, :dst
    def initialize(unit, unit_area, dst)
      @unit = unit
      @unit_area = unit_area
      @dst = dst
    end
    # affected area
    def affected
      dst
    end
    
    def nationality
      unit.nationality
    end
    
    def prefix
      "#{@unit.type_to_s} #{unit_area.to_s}"
    end
  end

  class Hold < GenericOrder
    def initialize(unit, unit_area)
      super(unit, unit_area, unit_area)
    end
    
    def to_s
      "#{prefix} H"
    end
  end

  class Move < GenericOrder
    def to_s
      "#{prefix} -> #{@dst}"
    end
  end

  class Support < GenericOrder
    attr_accessor :src

    def initialize(unit, unit_area, src, dst)
      super(unit, unit_area, dst)
      @src = src
    end
    
    def to_s
      "#{prefix} S #{@src.to_s} -> #{@dst}"
    end
  end

  class SupportHold < GenericOrder
    def to_s
      "#{prefix} S #{@dst} H"
    end
  end

  class Convoy < GenericOrder
    attr_accessor :src
    def initialize(unit, unit_area, dst, src)
      super(unit, unit_area, dst, src)
      @src = src
    end
    
    def to_s
      "#{prefix} C #{@src} -> #{@dst}"
    end
  end
  
  class OrderWrapper
    UNRESOLVED = 0
    SUCCESS = 1
    FAILURE = 2
    
    attr_accessor :order
    attr_accessor :status
    attr_accessor :depends_on
    
    def initialize(order)
      @order = order
      @status = UNRESOLVED
      @depends_on = []
    end
    
    def unresolved?
      @status == UNRESOLVED
    end
    
    def to_s
      case @status
      when 0
        stat_str = :UNRESOLVED
      when 1
        stat_str = :SUCCESS
      when 2
        stat_str = :FAILURE
      end
      return order.to_s+", "+stat_str.to_s
    end
  end
end
