class CreatePushTimes < ActiveRecord::Migration
  def change
    create_table :push_times do |t|
      t.string :name
      t.integer :value

      t.timestamps
    end
  end
end
