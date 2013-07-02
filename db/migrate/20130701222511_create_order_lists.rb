class CreateOrderLists < ActiveRecord::Migration
  def change
    create_table :order_lists do |t|
      t.string :power
      t.string :orders
      t.references :state

      t.timestamps
    end
    add_index :order_lists, :state_id
  end
end
