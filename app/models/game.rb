class Game < ActiveRecord::Base
  has_many :power_assignments
  has_many :users, through: :power_assignments
  has_many :state

  attr_accessible :name, :power_assignments_attributes, :state
  
  accepts_nested_attributes_for :power_assignments, reject_if: proc { |a| a[:power].blank? }, :allow_destroy => true

  def current_state
  end
end
