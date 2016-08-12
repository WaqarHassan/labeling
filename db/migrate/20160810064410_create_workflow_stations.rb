class CreateWorkflowStations < ActiveRecord::Migration
  def change
    create_table :workflow_stations do |t|
   	  t.integer :workflow_id
      t.string :station_name

      t.timestamps null: false
    end
  end
end
