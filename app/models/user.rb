class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :game_users
  has_many :games, :through => :game_users, :uniq => true

  def game_associations(options = {:include => :power})
    self.game_users.find(:all, options)
  end

  def game_association(game)
    self.game_associations.where(:game_id => game.id).first
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
