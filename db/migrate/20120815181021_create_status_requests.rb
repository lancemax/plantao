class CreateStatusRequests < ActiveRecord::Migration
  def change
    create_table :status_requests do |t|
      t.string :name

      t.timestamps
    end
  end
end
