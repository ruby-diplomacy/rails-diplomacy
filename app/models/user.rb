class User 
  include DataMapper::Resource

  class NotAuthorizedError < Exception
  end

  property :id, Serial
  property :username, String, :required => true

  has n, :user_assignments
  has n, :games, :through => :user_assignments
  has n, :powers, :through => :user_assignments

  def power_for_chatroom(c)
    assignment = self.user_assignments.first(:game => c.game)
    assignment.power if assignment
  end

end
