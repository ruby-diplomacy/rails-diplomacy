class State < ActiveRecord::Base
  belongs_to :game
  attr_accessible :positions, :turn

  def to_gamestate
    state_parser = Diplomacy::StateParser.new
    state_parser.parse_units positions || ""
  end
end
