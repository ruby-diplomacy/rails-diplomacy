class Chatroom < ActiveRecord::Base
  belongs_to :game
  has_many :chatroom_power_associations
  has_many :powers, :through => :chatroom_power_associations

  def users_hash
    chatroom_power_associations.inject({}) do |hash, item|
      hash[item.power.name] = item.user
    end
  end

end
