module Diplomacy

  class Unit
    ARMY = 1
    FLEET = 2
    
    attr_accessor :nationality
    attr_accessor :type
    
    def initialize(nationality, type)
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
    def initialize
      self.default = AreaState.new
    end
    
    def area_state(area)
      self[area.abbrv]
    end
    
    def area_unit(area)
      if Area === area 
        return self[area.abbrv].unit
      elsif Symbol === area
        return self[area].unit
      end
    end
  end
end
