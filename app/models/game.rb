class Game < ActiveRecord::Base
  has_many :power_assignments
  has_many :users, through: :power_assignments

  attr_accessible :name, :power_assignments_attributes
  
  accepts_nested_attributes_for :power_assignments, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end