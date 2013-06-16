class State < ActiveRecord::Base
  belongs_to :game
  attr_accessible :positions, :turn
end
