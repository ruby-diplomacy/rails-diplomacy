class Chatroom < ActiveRecord::Base
  belongs_to :game
  has_many :chatroom_power_associations
  has_many :powers, :through => :chatroom_power_associations
  has_many :messages

  def users
   self.powers.user_assignments.users
  end

  def self.game_user(game, user)
    all(:game => game, :powers => [:id => game.power_for_user(user).id])
  end

  def add_power(power)
    _add_power(power)
    self.reload
  end

  def add_powers(powers)
    powers.each {|p| _add_power(p)}
    self.reload
  end

  private
  def _add_power(power)
    ChatroomPowerAssociation.first_or_create(:chatroom_id => self.id, :power_id => power.id)
  end

end
# == Schema Information
#
# Table name: chatrooms
#
#  id      :integer         not null, primary key
#  game_id :integer         not null
#

