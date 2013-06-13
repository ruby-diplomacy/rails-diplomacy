class User < ActiveRecord::Base
  has_many :power_assignments
  has_many :games, through: :power_assignments

  attr_accessible :name
end