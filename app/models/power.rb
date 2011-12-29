class Power 
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true, :unique => :variant
  belongs_to :variant
  has n, :user_assignments

  def user_for_game(g)
    user_assignments(:game => g).first.user
  end
end
