class CreateChatroomPowerAssociations < ActiveRecord::Migration
  def change
    create_table :chatroom_power_associations do |t|
      t.integer :chatroom_id
      t.integer :power_id

      t.timestamps
    end
  end
end
