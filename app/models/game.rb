class Game < ActiveRecord::Base

  has_many :user_assignments
  has_many :users, :through => :user_assignments
  belongs_to :variant
  has_many :powers, :through => :variant
  has_many :chatrooms

  validates_presence_of :variant_id

  def assign_user(user, power = nil)
    ua = self.user_assignments.where(:user_id => user.id).first_or_create
    if power
      ua.power = power
      ua.save
    end

    ua
  end


  def power_for_user(user)
    self.user_assignments(:user => user).first.power
  end


end
# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  title      :string(50)      not null
#  status     :integer         default(0), not null
#  start_time :datetime
#  variant_id :integer         not null
#

