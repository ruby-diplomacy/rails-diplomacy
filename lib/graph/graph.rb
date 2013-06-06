require 'set'
module Diplomacy
  class Area
    LAND_BORDER = 1
    SEA_BORDER = 2

    attr_accessor :name, :borders, :abbrv
    attr_accessor :supply_center
    attr_accessor :coasts

    def initialize(name, abbrv)
      @name = name
      @abbrv = abbrv
      @borders = {LAND_BORDER => [], SEA_BORDER => []}
      @coasts = []
    end

    def add_border(area, border_type)
      (borders[border_type] ||= Set.new) << area
    end
    
    def is_supply?
      @supply_center
    end
    
    def is_inland?
      !@borders[LAND_BORDER].empty? && @borders[SEA_BORDER].empty?
    end
    
    def is_coastal?
      !@borders[LAND_BORDER].empty? && !@borders[SEA_BORDER].empty?
    end
    
    def to_s
      "#{name} (#{abbrv})#{is_supply? ? " *": ""}"
    end
  end

  class Map
    attr_accessor :areas
    def initialize
      @areas = {}
    end

    def add_border_by_object(area1, area2, type)
      area1.add_border(area2, type)
      area2.add_border(area1, type)
    end

    def add_border(name1, name2, type)
      add_border_by_object(areas[name1], areas[name2], type)
    end
    
    def neighbours?(area1, area2, type)
      @areas[area1].borders[type].member? @areas[area2]
    end
  end
end
