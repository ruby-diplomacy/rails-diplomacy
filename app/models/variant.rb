class Variant < ActiveRecord::Base

  has_many :games
  has_many :powers
end
# == Schema Information
#
# Table name: variants
#
#  id   :integer         not null, primary key
#  name :string(50)      not null
#

