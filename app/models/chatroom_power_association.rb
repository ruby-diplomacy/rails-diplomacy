class ChatroomPowerAssociation < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :power

  def user
    user_assoc = chatroom.game.user_association_by_power(power)
    unless user_assoc.nil?
      user_assoc.user
    end
  end
end
