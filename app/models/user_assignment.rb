class UserAssignment < ActiveRecord::Base
  belongs_to :game 
  belongs_to :user
  belongs_to :power
end
# == Schema Information
#
# Table name: user_assignments
#
#  id       :integer         not null, primary key
#  game_id  :integer         not null
#  user_id  :integer         not null
#  power_id :integer
#

