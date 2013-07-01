class AddPhaseToGame < ActiveRecord::Migration
  def change
    add_column :games, :phase, :integer, limit: 1, default: 0
  end
end
