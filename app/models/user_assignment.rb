class UserAssignment < ActiveRecord::Base
  belongs_to :game 
  belongs_to :user
  belongs_to :power

  validates_presence_of :game_id
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, :scope => :game_id
  validates_uniqueness_of :game_id, :scope => :user_id
  validates_uniqueness_of :power_id, :scode => [:user_id, :game_id], :allow_nil => true

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

