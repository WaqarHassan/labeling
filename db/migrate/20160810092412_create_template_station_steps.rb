class CreateTemplateStationSteps < ActiveRecord::Migration
  def change
    create_table :template_station_steps do |t|
      t.integer :template_station_id
      t.integer :step_id

      t.timestamps null: false
    end
  end
end
