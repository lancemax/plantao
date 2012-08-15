class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :job_id
      t.integer :user_id
      t.integer :status_request_id
      t.timestamps
    end
  end
end
