class User < ActiveRecord::Base
  class NotAuthorizedError < Exception
  end
  has_many :user_assignments
  has_many :games, :through => :user_assignments
  has_many :powers, :through => :user_assignments

  validates :username, :length => {
          :minimum => 5, 
          :maximum => 24,
          :wrong_length => 'username must be between 5 and 24 characters'
        }


  def power_for_chatroom(c)
    ass = UserAssignment.first(:user_id => self.id, :game_id => c.game.id)
    assignment.power if assignment
  end

end
# == Schema Information
#
# Table name: users
#
#  id       :integer         not null, primary key
#  username :string(50)      not null
#

