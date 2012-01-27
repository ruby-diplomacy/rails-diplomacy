class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

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
#  id                     :integer         not null, primary key
#  username               :string(50)      not null
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

