class ChatroomPowerAssociation < ActiveRecord::Base
  belongs_to :chatroom
  belongs_to :power
end
# == Schema Information
#
# Table name: chatroom_power_associations
#
#  chatroom_id :integer
#  power_id    :integer         not null
#

