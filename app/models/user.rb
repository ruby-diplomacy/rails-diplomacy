class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :game_users, :include => :power
  has_many :games, :through => :game_users, :uniq => true
  scope 

  def game_association(game)
    self.game_users.where(:game_id => game.id).first
  end

  def power_for_game(game)
    self.game_association(game).power
  end

  def assign_power_for_game(attrs)
    assoc = self.game_association(attrs[:game])
    assoc.power = attrs[:power]
    assoc.save
  end
end
