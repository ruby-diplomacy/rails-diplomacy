class Game < ActiveRecord::Base
  has_many :power_assignments
  has_many :users, through: :power_assignments
  has_many :states

  attr_accessible :name, :power_assignments_attributes, :states
  
  accepts_nested_attributes_for :power_assignments, reject_if: proc { |a| a[:power].blank? }, :allow_destroy => true

  after_create :create_initial_state

  def current_state
    states.order("turn DESC").first
  end

  def create_initial_state
    mr = Diplomacy::MapReader.new
    sp = Diplomacy::StateParser.new mr.maps['Standard'].starting_state
    states.create turn: 1, state: sp.dump_state
  end
end
