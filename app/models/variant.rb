class Variant 
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true
  has n, :games
  has n, :powers

end
