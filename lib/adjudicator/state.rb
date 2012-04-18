module Diplomacy

  class Unit
    ARMY = 1
    FLEET = 2
    
    attr_accessor :nationality
    attr_accessor :type
    
    def initialize(nationality=nil, type=nil)
      @nationality = nationality
      @type = type
    end

    def is_army?
      type == ARMY
    end

    def is_fleet?
      type == FLEET
    end

    def type_to_s
      return "A" if is_army?
      return "F" if is_fleet?
      return "Unknown"
    end
  end

  class AreaState
    attr_accessor :nationality
    attr_accessor :unit

    def initialize(nationality = nil, unit = nil)
      @owner = nationality
      @unit = unit
    end
  end

  class GameState < Hash
    attr_accessor :retreats
    
    def initialize
      self.default = AreaState.new
      self.retreats = {}
    end
    
    def area_state(area)
      if Area === area
        self[area.abbrv]
      elsif Symbol === area
        return self[area]
      end
    end
    
    def area_unit(area)
      area_state(area).unit
    end
    
    def set_area_unit(area, unit)
      area_state(area).unit = unit
    end
    
    def apply_orders!(orders)
      orders.each do |order|
        if Move === order && order.succeeded?
          @retreats[order.dst] = area_unit(order.dst)
          
          set_area_unit(order.dst, area_unit(order.unit_area))
          set_area_unit(order.unit_area, nil)
        end
      end
    end
  end
end
