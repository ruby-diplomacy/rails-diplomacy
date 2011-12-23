class Game
  include DataMapper::Resource
  property :id, Serial
  property :title, String, :required => true
  property :status, Integer, :required => true, :default => 0
  property :start_time, DateTime

  has n, :user_assignments
  has n, :users, :through => :user_assignments
  belongs_to :variant
  has n, :powers, :through => :variant

  def assign_user(user, power = nil)
    u = self.user_assignments.first_or_create(:user => user)
    u.power = power if power
    self.save
  end


  def power_for_user(user)
    self.user_assignments(:user => user).first.power
  end

end
