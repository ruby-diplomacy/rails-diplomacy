class Message < ActiveRecord::Base

  belongs_to :power
  belongs_to :chatroom

  validates_presence_of :text
  validates_presence_of :power_id
  validates_presence_of :chatroom_id

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
#  power_id    :integer
#  chatroom_id :integer
#

