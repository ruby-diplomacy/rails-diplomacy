class Message < ActiveRecord::Base
  belongs_to :power
  belongs_to :chatroom

end
