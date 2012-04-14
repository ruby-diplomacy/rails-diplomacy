class Order < ActiveRecord::Base

  belongs_to :state
  belongs_to :power

  validates_presence_of :order, message: "You must supply an order"
end
