class AddLabelingIndex < ActiveRecord::Migration
	def up
		add_index(:workflow_stations, [:work_flow_id, :is_visible])
	    add_index(:station_steps, :workflow_station_id)
	    add_index(:work_flows, [:is_active, :is_in_use])
	    add_index(:workflow_live_steps, [:object_id, :object_type])
	    add_index(:attribute_values, [:object_id, :object_type])
	    add_index(:l3s, :l2_id)
	    add_index(:l2s, :l1_id)
	    add_index(:l1s, [:work_flow_id, :status])
	    add_index(:l1s, :work_flow_id)
	    add_index(:l1s, [:name, :work_flow_id])
	    add_index(:l1s, :name)
	    add_index(:l2s, :name)
	    add_index(:l3s, :name)
	    add_index(:l1s, :business_unit)
	    add_index(:l2s, :business_unit)
	    add_index(:l3s, :business_unit)
	    add_index(:l1s, [:name, :business_unit])
	    add_index(:l2s, [:name, :business_unit])
	    add_index(:l3s, [:name, :business_unit])
	    add_index(:l1s, [:name, :business_unit, :work_flow_id])
	    add_index(:additional_infos, [:work_flow_id, :object_id, :object_type], :name => 'fk_additional_infos_index')
	    add_index(:bu_options, [:work_flow_id, :recording_level])
	    add_index(:statuses, [:work_flow_id, :recording_level])
	    add_index(:label_attributes, [:work_flow_id, :recording_level, :is_visible], :name => 'fk_label_attributes_index')
	    add_index(:station_steps, [:workflow_station_id, :recording_level])
	    add_index(:work_flows, :is_in_use)
	    add_index(:holidays, :work_flow_id)
	    add_index(:transitions, :station_step_id)

	end
	def down
		remove_index(:workflow_stations, [:work_flow_id, :is_visible])
	    remove_index(:station_steps, :workflow_station_id)
	    remove_index(:work_flows, [:is_active, :is_in_use])
	    remove_index(:workflow_live_steps, [:object_id, :object_type])
	    remove_index(:attribute_values, [:object_id, :object_type])
	    remove_index(:l3s, :l2_id)
	    remove_index(:l2s, :l1_id)
	    remove_index(:l1s, [:work_flow_id, :status])
	    remove_index(:l1s, :work_flow_id)
	    remove_index(:l1s, [:name, :work_flow_id])
	    remove_index(:l1s, :name)
	    remove_index(:l2s, :name)
	    remove_index(:l3s, :name)
	    remove_index(:l1s, :business_unit)
	    remove_index(:l2s, :business_unit)
	    remove_index(:l3s, :business_unit)
	    remove_index(:l1s, [:name, :business_unit])
	    remove_index(:l2s, [:name, :business_unit])
	    remove_index(:l3s, [:name, :business_unit])
	    remove_index(:l1s, [:name, :business_unit, :work_flow_id])
	    remove_index(:additional_infos, [:work_flow_id, :object_id, :object_type], :name => 'fk_additional_infos_index')
	    remove_index(:bu_options, [:work_flow_id, :recording_level])
	    remove_index(:statuses, [:work_flow_id, :recording_level])
	    remove_index(:label_attributes, [:work_flow_id, :recording_level, :is_visible], :name => 'fk_label_attributes_index')
	    remove_index(:station_steps, [:workflow_station_id, :recording_level])
	    remove_index(:work_flows, :is_in_use)
	    remove_index(:holidays, :work_flow_id)
	    remove_index(:transitions, :station_step_id)
	end
end
