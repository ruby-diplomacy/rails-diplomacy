class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :game_users
  has_many :games, :through => :game_users


end
