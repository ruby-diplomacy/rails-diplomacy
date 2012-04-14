class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :state_id
      t.integer :power_id
      t.string :order

      t.timestamps
    end
  end
end
