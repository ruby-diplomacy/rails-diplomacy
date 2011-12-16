class Message
  include DataMapper::Resource

  property :id, Serial
  property :text, String
  belongs_to :power
  belongs_to :chatroom
  has 1, :game, {:through => :chatroom}

end
