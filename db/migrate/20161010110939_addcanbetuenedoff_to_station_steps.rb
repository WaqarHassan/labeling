class AddcanbetuenedoffToStationSteps < ActiveRecord::Migration
  def change
  	add_column :station_steps, :can_be_turned_off, :boolean, :default => true
  end
end
