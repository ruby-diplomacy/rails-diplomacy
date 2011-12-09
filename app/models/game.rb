class Game < ActiveRecord::Base

  has_many :game_users
  has_many :users, :through => :game_users
  belongs_to :variant
  has_many :powers, :through => :variant

  def user_for_power(power)
    self.game_users.where(:power_id => power.id).user
  end


end
