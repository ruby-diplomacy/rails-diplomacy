class Variant < ActiveRecord::Base

  has_many :games
  has_many :powers


  def self.options_for_select
    Variant.select([:id, :name]).collect do |v|
      [v.name, v.id]
    end
  end
end
# == Schema Information
#
# Table name: variants
#
#  id   :integer         not null, primary key
#  name :string(50)      not null
#

