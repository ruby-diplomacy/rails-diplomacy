class ConnectMessagesToChatroomPowerAssociation < ActiveRecord::Migration

  def change
    remove_column :messages, :power_id
    remove_column :messages, :chatroom_id
    add_column :messages, :chatroom_power_association_id, :integer
  end
end
