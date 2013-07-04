require 'parser/state_parser'
require 'parser/order_parser'

Diplomacy.logger = Logger.new RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null'

::MAP_READER = Diplomacy::MapReader.new
::ADJUDICATOR = Diplomacy::Adjudicator.new ::MAP_READER.maps['Standard']
