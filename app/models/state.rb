class State < ActiveRecord::Base
  belongs_to :game
  has_many :order_lists, dependent: :destroy
  attr_accessible :state, :turn, :season, :year

  validates :game, presence: true
  validates :turn, uniqueness: { scope: :game_id } # NB: this isn't 100%, but we don't care much

  def bundle_orders
    bundle = []
    self.order_lists.each do |order_list|
      bundle << "#{order_list.orders}" if order_list.orders.present?
    end
    bundle.join(",")
  end

  def all_order_lists_confirmed?
    powers = []
    self.order_lists.each do |order_list|
      if order_list.confirmed
        powers << order_list.power
      else
        return false # even one unconfirmed order list stops progression
      end
    end
    return (self.game.powers - powers).length == 0
  end

  def is_fall?
    self.season == 'Fall'
  end

  def is_spring?
    self.season == 'Spring'
  end

  def progress_season!
    case self.season
    when 'Fall'
      self.season = 'Spring'
      self.year += 1
    when 'Spring'
      self.season = 'Fall'
    end
    self.save
  end

  def sc_list_per_power
    gs = self.to_gamestate
  	supply_centers = MAP_READER.maps['Standard'].supply_centers
    result = {}
    supply_centers.each do |abbrv, area|
      area_state = gs[abbrv]
      unless area_state.owner.nil?
        (result[area_state.owner] ||= Array.new) << abbrv
      end
    end
    result
  end

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
