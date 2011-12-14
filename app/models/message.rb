class Message < ActiveRecord::Base
  belongs_to :power
  belongs_to :chatroom

  validates_presence_of :chatroom
  validates_presence_of :power

end
