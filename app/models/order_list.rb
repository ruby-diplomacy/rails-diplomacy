class OrderValidator < ActiveModel::Validator
	def validate(record)
    if record.orders.nil?
      record.errors[:orders] << "Cannot be nil"
    else
      sp = Diplomacy::StateParser.new
      state = sp.parse_state(record.state.state)
      op = Diplomacy::OrderParser.new state

      begin
        orders = op.parse_orders record.orders

        orders.each do |order|

        end
      rescue Diplomacy::WrongOrderTypeError => wote
        record.errors[:orders] << wote.message
      rescue Diplomacy::OrderParsingError => ope
        record.errors[:orders] << ope.message
      end
    end
  end
end

class OrderList < ActiveRecord::Base
  belongs_to :state
  attr_accessible :orders, :power, :state, :state_id, :confirmed

  validates :power, :state, presence: true
  validates_with OrderValidator

  before_create :destroy_previous
  after_save :check_progress_game

  def destroy_previous
    previous = OrderList.where(state_id: self.state.id, power: power).destroy_all
  end

  def check_progress_game
    self.state.game.progress_phase! if self.state.all_order_lists_confirmed?
  end
end
