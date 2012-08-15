class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :hospital_id
      t.integer :area_id
      t.integer :user_id
      t.text :dependencies
      t.timestamp :date
      t.integer :shift_id
      t.integer :price
      t.text :description
      t.integer :request_id

      t.timestamps
    end
  end
end
