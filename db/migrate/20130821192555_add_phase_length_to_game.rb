class AddPhaseLengthToGame < ActiveRecord::Migration
  def change
    add_column :games, :phase_length, :integer, default: 720
    add_column :games, :next_phase, :datetime
  end
end
