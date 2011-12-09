class GameUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :power

  scope :with_power, where("power_id IS NOT NULL")
  scope :without_power, where(:power_id => nil)
end
