class CreatePowerAssignments < ActiveRecord::Migration
  def change
    create_table :power_assignments do |t|
      t.references :game
      t.references :user
      t.string :power

      t.timestamps
    end
    add_index :power_assignments, :game_id
    add_index :power_assignments, :user_id
  end
end