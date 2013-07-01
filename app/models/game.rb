class Game < ActiveRecord::Base
  has_many :power_assignments
  has_many :users, through: :power_assignments
  has_many :states

  attr_accessible :name, :power_assignments_attributes, :states, :phase
  
  accepts_nested_attributes_for :power_assignments, reject_if: proc { |a| a[:power].blank? }, :allow_destroy => true

  after_create :create_initial_state

  PHASES = {
    awaiting_players: 0,
    movement: 1,
    adjudication: 2,
    retreats: 3,
    supply: 4,
    finished: 5
  }

  def powers
    MAP_READER.maps['Standard'].powers.keys
  end

  def current_state
    states.order("turn DESC").first
  end

  def create_initial_state
    sp = Diplomacy::StateParser.new MAP_READER.maps['Standard'].starting_state
    states.create turn: 1, state: sp.dump_state
  end
end
