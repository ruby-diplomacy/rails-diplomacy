class State < ActiveRecord::Base
  belongs_to :game
  has_many :order_lists
  attr_accessible :state, :turn, :season, :year

  def bundle_orders
    bundle = []
    self.order_lists.each do |order_list|
      bundle << "#{order_list.orders}" if order_list.orders.present?
    end
    bundle.join(",")
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
