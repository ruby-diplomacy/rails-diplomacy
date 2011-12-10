require 'set'
module Diplomacy
  class Area
    LAND_BORDER = 1
    SEA_BORDER = 2
    COAST_BORDER = 3

    attr_accessor :name, :borders, :abbrv
    attr_accessor :supply_center

    def initialize(name, abbrv)
      @name = name
      @abbrv = abbrv
      @borders = {}
    end

    def add_border(area, border_type)
      (borders[border_type] ||= Set.new) << area
    end

    def is_supply?
      @supply_center
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
  end
end
