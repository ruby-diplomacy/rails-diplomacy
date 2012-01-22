class Power < ActiveRecord::Base
  
  belongs_to :variant
  has_many :user_assignments

  validates_presence_of :variant_id

  def user_for_game(g)
    user_assignments(:game => g).first.user
  end
end
# == Schema Information
#
# Table name: powers
#
#  id         :integer         not null, primary key
#  name       :string(50)      not null
#  variant_id :integer         not null
#

