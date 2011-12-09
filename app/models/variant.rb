class Variant < ActiveRecord::Base
  has_many :games
  has_many :powers

  validates_presence_of :name
  validates_uniqueness_of :name
end
