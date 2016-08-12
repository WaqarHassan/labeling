class CreateStationSteps < ActiveRecord::Migration
  def change
    create_table :station_steps do |t|
      t.integer :workflow_station_id
      t.string :step_name
      t.string :recording_level
      t.integer :sequence
      t.boolean :is_visible

      t.timestamps null: false
    end
  end
end
