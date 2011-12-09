class AddPowerIdToGameUser < ActiveRecord::Migration
  def change
    add_column :game_users, :power_id, :integer
  end
end
