class CreateTemplateStations < ActiveRecord::Migration
  def change
    create_table :template_stations do |t|
   	  t.integer :template_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
