class CreateWorkflowStations < ActiveRecord::Migration
  def change
    create_table :workflow_stations do |t|
   	  t.integer :work_flow_id
      t.string :station_name
      t.integer :sequence
      t.boolean :is_visible

      t.timestamps null: false
    end
  end
end
