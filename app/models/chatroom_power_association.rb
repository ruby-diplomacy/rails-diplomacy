class ChatroomPowerAssociation 
  include DataMapper::Resource
  belongs_to :chatroom, :key => true
  belongs_to :power, :key => true

end
