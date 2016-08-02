class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :name
      t.integer :recording_level
      t.integer :sequence
      t.boolean :is_visible
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
