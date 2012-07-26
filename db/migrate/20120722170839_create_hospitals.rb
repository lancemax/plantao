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
      
      #for image
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
