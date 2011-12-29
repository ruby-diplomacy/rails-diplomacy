class State
  include DataMapper::Resource

  property :id, Serial
  property :turn, Integer, :required => true
  property :state, String, :required => true
  belongs_to :game
end
