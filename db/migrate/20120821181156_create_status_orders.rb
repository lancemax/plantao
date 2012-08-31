class CreateStatusOrders < ActiveRecord::Migration
  def change
    create_table :status_orders do |t|
      t.string :name

      t.timestamps
    end
  end
end
