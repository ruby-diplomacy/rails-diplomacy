class Power < ActiveRecord::Base
  belongs_to :variant

  validates :name, :presence => true, :uniqueness => {:scope =>:variant_id, :message => 'should be unique for a variant'}
end
