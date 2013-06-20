class RenamePositionToState < ActiveRecord::Migration
  def up
    rename_column :states, :positions, :state
  end

  def down
    rename_column :states, :state, :positions
  end
end
