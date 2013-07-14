class AddConfirmedToOrderList < ActiveRecord::Migration
  def change
    add_column :order_lists, :confirmed, :boolean, default: false
  end
end
