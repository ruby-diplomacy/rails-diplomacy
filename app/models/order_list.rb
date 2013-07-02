class OrderValidator < ActiveModel::Validator
	def validate(record)
    # this code is unintuitive at best, I wonder who wrote that damn gem
    sp = Diplomacy::StateParser.new
    orders = []
    op = Diplomacy::OrderParser.new sp.parse_state(record.state.state), orders

    op.parse_orders record.orders

    unless orders.compact!.nil?
      record.errors[:orders] << "Invalid order list"
    end
  end
end

class OrderList < ActiveRecord::Base
  belongs_to :state
  attr_accessible :orders, :power, :state, :state_id

  validates_with OrderValidator

  before_create :destroy_previous

  def destroy_previous
    previous = OrderList.where(state_id: self.state.id, power: power).destroy_all
  end
end
