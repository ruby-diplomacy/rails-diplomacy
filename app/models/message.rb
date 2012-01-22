class Message < ActiveRecord::Base

  belongs_to :power
  belongs_to :chatroom

  def game
    self.chatroom.game
  end
end
# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  text        :string(50)
#  power_id    :integer         not null
#  chatroom_id :integer         not null
#

