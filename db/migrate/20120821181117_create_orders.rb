class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :package_id
      t.integer :status_order_id
      t.float :price

      t.timestamps
    end
  end
end
