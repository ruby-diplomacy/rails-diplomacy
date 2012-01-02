class Chatroom
  include DataMapper::Resource
  property :id, Serial
  belongs_to :game
  has n, :chatroom_power_associations
  has n, :powers, :through => :chatroom_power_associations
  has n, :messages

  def users
   self.powers.user_assignments.users
  end

  def self.game_user(game, user)
    all(:game => game, :powers => [:id => game.power_for_user(user).id])
  end

end
