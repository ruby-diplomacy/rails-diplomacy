class State < ActiveRecord::Base
  belongs_to :game
  attr_accessible :state, :turn

  def to_gamestate
    state_parser = Diplomacy::StateParser.new
    state_parser.parse_units_by_power positions || ""
  end
end
