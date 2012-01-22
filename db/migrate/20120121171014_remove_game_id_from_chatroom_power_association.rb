class RemoveGameIdFromChatroomPowerAssociation < ActiveRecord::Migration

	change_table :chatroom_power_associations do |t|
		t.remove :game_id
	end
end
