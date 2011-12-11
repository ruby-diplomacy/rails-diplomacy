class CreateChatrooms < ActiveRecord::Migration
  def change
    create_table :chatrooms do |t|
      t.integer :game_id

      t.timestamps
    end
  end
end
