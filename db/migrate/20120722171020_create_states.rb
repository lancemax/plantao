class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :acronym ,:limit => 2

      t.timestamps
    end
  end
end
