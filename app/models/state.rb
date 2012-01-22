class State < ActiveRecord::Base

  belongs_to :game
end
# == Schema Information
#
# Table name: states
#
#  id      :integer         not null, primary key
#  turn    :integer         not null
#  state   :string(50)      not null
#  game_id :integer         not null
#

