class AddColumnToReworkInfo < ActiveRecord::Migration
  def change
  	remove_column :rework_infos, :collab_name
  	remove_column :rework_infos, :time_stamp
  	remove_column :rework_infos, :user_id
  	remove_column :rework_infos, :station_id
  	remove_column :rework_infos, :reason
  	remove_column :rework_infos, :comp_number
  	remove_column :rework_infos, :type
  	remove_column :rework_infos, :l3_id

    add_column :rework_infos, :object_id, :integer
    add_column :rework_infos, :object_type, :string
    add_column :rework_infos, :step_initiating_rework, :integer
    add_column :rework_infos, :rework_start_step, :integer
    add_column :rework_infos, :reason, :integer
    add_column :rework_infos, :user_id, :integer
  end
end
