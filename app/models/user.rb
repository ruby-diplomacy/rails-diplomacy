class User < ActiveRecord::Base
  class NotAuthorizedError < Exception
  end
  has_many :user_assignments
  has_many :games, :through => :user_assignments
  has_many :powers, :through => :user_assignments

  validates :username, :length => {
          :minimum => 4, 
          :maximum => 24,
          :wrong_length => 'username must be between 4 and 24 characters'
        }


  def power_for_chatroom(c)
    power_for_game(c.game)
  end

  def power_for_game(g)
    ass = self.user_assignments.where(:game_id => g.id).first
    ass.power if ass
  end

end
# == Schema Information
#
# Table name: users
#
#  id       :integer         not null, primary key
#  username :string(50)      not null
#

