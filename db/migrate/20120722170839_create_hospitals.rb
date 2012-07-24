class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :address
      t.string :complement
      t.string :neighborhood
      t.integer :zip_code
      t.integer :city_id
      t.integer :state_id
      t.text :description
      t.string :photo

      t.timestamps
    end
  end
end
