class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :game_id
      t.integer :turn
      t.string :state

      t.timestamps
    end
  end
end
