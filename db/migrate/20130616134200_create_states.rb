class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :turn
      t.string :positions
      t.references :game

      t.timestamps
    end
    add_index :states, :game_id
  end
end
