class Game < ActiveRecord::Base
  has_many :power_assignments, dependent: :destroy
  has_many :users, through: :power_assignments
  has_many :states, dependent: :destroy

  attr_accessible :name, :power_assignments_attributes, :states, :phase
  
  accepts_nested_attributes_for :power_assignments, reject_if: proc { |a| a[:power].blank? }, :allow_destroy => true

  validates :name, presence: true

  PHASES = {
    awaiting_players: 0,
    movement: 1,
    retreats: 2,
    supply: 3,
    finished: 4
  }

  default_scope order('created_at DESC')
  scope :available, -> { where(phase: PHASES[:awaiting_players]) }
  scope :finished, -> { where(phase: PHASES[:finished]) }
  scope :ongoing, -> { where(phase: PHASES.values_at(:movement, :retreats, :supply)) }

  # START CALLBACK METHODS ========================
  after_create :create_initial_state

  def create_initial_state
    sp = Diplomacy::StateParser.new MAP_READER.maps['Standard'].starting_state
    states.create turn: 1, state: sp.dump_state
  end

  # END CALLBACK METHODS ==========================

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
    previous_state_record = self.current_state
    sp = Diplomacy::StateParser.new
    previous_state = sp.parse_state(previous_state_record.state)
    op = Diplomacy::OrderParser.new previous_state

    case self.phase
    when PHASES[:awaiting_players]
      self.phase = PHASES[:movement]
    when PHASES[:movement]
      # adjudicate orders
      adjust = previous_state_record.is_fall? # if it was fall, also adjust ownership of areas
      new_state, adjudicated_orders = ADJUDICATOR.resolve! previous_state, op.parse_orders(previous_state_record.bundle_orders), adjust
      new_state_record = create_new_state_record(new_state, previous_state_record)

      if not new_state.retreats.empty?
        # if there are retreats, go to retreats
        self.phase = PHASES[:retreats]
      elsif previous_state_record.is_fall?
        # if not, and it's Fall, go to supply
        self.phase = PHASES[:supply]
      else
        # otherwise, just go to movement again
        new_state_record.progress_season!
        self.phase = PHASES[:movement]
      end
    when PHASES[:retreats]
      # adjudicate retreats
      adjust = previous_state_record.is_fall? # if it was fall, also adjust ownership of areas
      new_state, adjudicated_orders = ADJUDICATOR.resolve_retreats! previous_state, op.parse_orders(previous_state_record.bundle_orders), adjust
      new_state_record = create_new_state_record(new_state, previous_state_record)

      # if it's Fall, go to supply, otherwise to movement
      if previous_state_record.is_fall?
        self.phase = PHASES[:supply]
      else
        new_state_record.progress_season!
        self.phase = PHASES[:movement]
      end
    when PHASES[:supply]
      # adjudicate builds
      new_state, adjudicated_orders = ADJUDICATOR.resolve_builds! previous_state, op.parse_orders(previous_state_record.bundle_orders)
      new_state_record = create_new_state_record(new_state, previous_state_record)

      # if someone won, go to finished, otherwise to movement
      if false # TODO someone won
        self.phase = PHASES[:finished]
      else
        new_state_record.progress_season!
        self.phase = PHASES[:movement]
      end
    end

    self.save
  end

  def phase_name
    PHASES.each do |name, val|
      if val == self.phase
        return name.to_s.gsub(/_/, " ").capitalize
      end
    end
  end

  private

  def create_new_state_record(new_state, previous_state_record)
    dumper = Diplomacy::StateParser.new new_state

    # save adjudicated orders and create new state
    return self.states.create(
      state: dumper.dump_state,
      turn: previous_state_record.turn + 1,
      season: previous_state_record.season,
      year: previous_state_record.year
    )
  end
end
