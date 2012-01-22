class ChatroomPowerAssociation < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :power

  validates_presence_of :chatroom_id
  validates_presence_of :power_id
  validates_uniqueness_of :chatroom_id, :scope => :power_id
  validates_uniqueness_of :power_id, :scope => :chatroom_id
  validate :power_must_belong_to_game


  def power_must_belong_to_game
    unless chatroom.game.powers.map(&:id).include?(power_id)
      errors.add(:power_id, 'must belong to the chatroom game')
    end
  end
end
# == Schema Information
#
# Table name: chatroom_power_associations
#
#  chatroom_id :integer
#  power_id    :integer         not null
#

