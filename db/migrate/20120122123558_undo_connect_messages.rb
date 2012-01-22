class UndoConnectMessages < ActiveRecord::Migration 
  def change
    add_column :messages, :power_id, :integer
    add_column :messages, :chatroom_id, :integer
    remove_column :messages, :chatroom_power_association_id
  end
end
