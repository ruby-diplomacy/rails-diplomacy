class AddPhaseLengthToGame < ActiveRecord::Migration
  def change
    add_column :games, :phase_length, :integer, default: 1440
    add_column :games, :next_phase, :datetime
  end
end
