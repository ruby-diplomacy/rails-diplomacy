class User 
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :required => true

  has n, :user_assignments
  has n, :games, :through => :user_assignments
  has n, :powers, :through => :user_assignments

  def assign_power_for_game(game, power = nil)
    game.assign_user(self, power)
  end

  def power_for_chatroom(c)
    self.user_assignments.first(:game => c.game).power
  end

end
