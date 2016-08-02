class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.integer :sequence
      t.boolean :is_visible

      t.timestamps null: false
    end
  end
end
