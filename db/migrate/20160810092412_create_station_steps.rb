class CreateStationSteps < ActiveRecord::Migration
  def change
    create_table :station_steps do |t|
      t.integer :workflow_station_id
      t.string :step_name
      t.string :recording_level
      t.integer :sequence
      t.integer :duration_days
      t.integer :duration_minutes
      t.string :duration_multiplier
      t.boolean :is_visible

      t.timestamps null: false
    end
  end
end
