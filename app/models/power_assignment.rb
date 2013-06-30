class PowerAssignment < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  
  attr_accessible :power, :game_id
end
