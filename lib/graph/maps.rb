require 'yaml'

module Diplomacy
  class MapReader
    attr_accessor :maps
    
    def initialize
      @maps = {}
    end
    
    def read_map_file(yaml_file)
      yamlmaps = YAML::load_file(yaml_file)
      
      yamlmaps.keys.each do |mapname|
        yamlmap = yamlmaps[mapname]
        map = Map.new
        yamlmap['Areas'].each do |area|
          map.areas[area[0].to_sym] = Area.new(area[1].to_sym, area[0].to_sym)
        end
        
        yamlmap['Borders'].each do |border|
          border_types = border[2..-1]
          if border_types.member? "L"
            map.add_border(border[0].to_sym, border[1].to_sym, Area::LAND_BORDER)
          end
          if border_types.member? "S"
            map.add_border(border[0].to_sym, border[1].to_sym, Area::SEA_BORDER)
          end
        end
        
        @maps[mapname] = map
      end
    end
  end
end
