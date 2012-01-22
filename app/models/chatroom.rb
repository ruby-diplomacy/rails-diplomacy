class Chatroom < ActiveRecord::Base
  belongs_to :game
  has_many :chatroom_power_associations
  has_many :powers, :through => :chatroom_power_associations
  has_many :messages

  validates_presence_of :game_id
  scope :power_game, ->(power, game) {
    joins(:chatroom_power_associations).where('chatroom_power_associations.power_id = ? AND chatrooms.game_id = ?', power.id, game.id)
  }

  def users
    ids = UserAssignment.where(:game_id => game.id, :power_id => powers.map(&:id)).pluck(:id)
    User.find(ids)
  end

  def add_power(power)
    _add_power(power)
    self.reload
  end

  def add_powers(ps)
    ps.each {|p| _add_power(p)}
    self.reload
  end

  private
  def _add_power(power)
    c = ChatroomPowerAssociation.where(:chatroom_id => self.id, :power_id => power.id).first_or_create
  end

end
# == Schema Information
#
# Table name: chatrooms
#
#  id      :integer         not null, primary key
#  game_id :integer         not null
#

