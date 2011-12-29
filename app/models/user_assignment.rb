class UserAssignment 
  include DataMapper::Resource
  belongs_to :game, :key => true
  belongs_to :user, :key => true
  belongs_to :power, :required => false, :unique  => true

end
