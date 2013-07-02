class State < ActiveRecord::Base
  belongs_to :game
  has_many :order_lists
  attr_accessible :state, :turn

  def to_gamestate
    state_parser = Diplomacy::StateParser.new
    state_parser.parse_state state || ""
  end

  # OBSERVE AND BEWARE
  # There is actually no way to get a state
  # without a game now. Who needs one anyway.
  def to_param
    turn
  end
end
