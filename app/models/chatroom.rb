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

  def add_power(power)
    _add_power(power)
    self.reload
  end

  def add_powers(powers)
    powers.each {|p| _add_power(p)}
    self.reload
  end

  private
  def _add_power(power)
    cp = self.chatroom_power_associations.first_or_create(:power => power)
  end

end
