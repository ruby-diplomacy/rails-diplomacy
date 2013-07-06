class DontAllowNilOrders < ActiveRecord::Migration
  def change
    change_column :order_lists, :orders, :string, default: ""
  end
end
