class GameUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :power

  validates_uniqueness_of :user_id, :scope => [:game_id]

  scope :with_power, where("power_id IS NOT NULL")
  scope :without_power, where(:power_id => nil)

  def power_name
    if power_id.nil?
      "Unassigned"
    else
      power.name
    end
  end
end
