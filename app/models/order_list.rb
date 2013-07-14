class OrderValidator < ActiveModel::Validator
	def validate(record)
    if record.orders.nil?
      record.errors[:orders] << "Cannot be nil"
    else
      # this code is unintuitive at best, I wonder who wrote that damn gem
      sp = Diplomacy::StateParser.new
      state = sp.parse_state(record.state.state)
      op = Diplomacy::OrderParser.new state

      orders = op.parse_orders record.orders

      unless orders.compact!.nil?
        record.errors[:orders] << "Invalid order list"
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

  def destroy_previous
    previous = OrderList.where(state_id: self.state.id, power: power).destroy_all
  end
end
