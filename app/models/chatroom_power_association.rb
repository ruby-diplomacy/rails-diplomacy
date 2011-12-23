class ChatroomPowerAssociation 
  include DataMapper::Resource
  belongs_to :chatroom, :key => true
  belongs_to :power, :key => true

  validates_with_method :check_power

  def check_power
    self.chatroom.game.powers.include? self.power
  end


end
