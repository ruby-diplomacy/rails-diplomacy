class Game < ActiveRecord::Base

  has_many :game_users
  has_many :users, :through => :game_users, :uniq => true
  belongs_to :variant
  has_many :powers, :through => :variant, :uniq => true

  def user_associations(options = {:include => :power})
    self.game_users.find(:all, options)
  end

  def user_association(user)
    self.user_associations.where(:user_id => user.id).first
  end

  def power_assignments
    self.user_associations.with_power
  end

  def assigned_powers
    power_assigments.collect {|a| a.power}
  end

  def unassigned_powers
    powers - assigned_powers
  end

end
