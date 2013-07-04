require 'parser/state_parser'
require 'parser/order_parser'

::MAP_READER = Diplomacy::MapReader.new
::ADJUDICATOR = Diplomacy::Adjudicator.new ::MAP_READER.maps['Standard']
