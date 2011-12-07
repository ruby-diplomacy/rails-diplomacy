class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.timestamp :start_time
      t.integer :variant_id
      t.integer :status

      t.timestamps
    end
  end
end
