class Game < ActiveRecord::Base
  has_many :power_assignments
  has_many :users, through: :power_assignments
  has_many :states

  attr_accessible :name, :power_assignments_attributes, :states, :phase
  
  accepts_nested_attributes_for :power_assignments, reject_if: proc { |a| a[:power].blank? }, :allow_destroy => true

  PHASES = {
    awaiting_players: 0,
    movement: 1,
    retreats: 2,
    supply: 3,
    finished: 4
  }

  after_create :create_initial_state

  def create_initial_state
    sp = Diplomacy::StateParser.new MAP_READER.maps['Standard'].starting_state
    states.create turn: 1, state: sp.dump_state
  end

  # END HOOK METHODS ==========================

  def powers
    MAP_READER.maps['Standard'].powers.keys
  end

  def current_state
    states.order("turn DESC").first
  end

  def started?
    not [PHASES[:awaiting_players], PHASES[:finished]].member? self.phase
  end

  def progress_phase!
    case self.phase
    when PHASES[:awaiting_players]
      self.phase = PHASES[:movement]
    when PHASES[:movement]
      current_state = self.current_state

      sp = Diplomacy::StateParser.new
      previous_state = sp.parse_state(current_state.state)
      op = Diplomacy::OrderParser.new previous_state

      # adjudicate orders
      new_state, adjudicated_orders = ADJUDICATOR.resolve! previous_state, op.parse_orders(current_state.bundle_orders)
      dumper = Diplomacy::StateParser.new new_state

      # save adjudicated orders and create new state
      self.states.create(state: dumper.dump_state, turn: current_state.turn + 1)

      if not new_state.retreats.empty?
        # if there are retreats, go to retreats
        self.phase = PHASES[:retreats]
      elsif false
        # if not, and it's Fall, go to supply
        # if Fall
        self.phase = PHASES[:supply]
      else
        # otherwise, just go to movement again
        self.phase = PHASES[:movement]
      end
    when PHASES[:retreats]
      # if it's Fall, go to supply, otherwise to movement
    when PHASES[:supply]
      # if someone won, go to finished, otherwise to movement
    end

    self.save
  end
end
