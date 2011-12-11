class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :chatroom_id
      t.string :text
      t.integer :power_id

      t.timestamps
    end
  end
end
