class AddColumnToWorkFlows2 < ActiveRecord::Migration
  def change
    add_column :work_flows, :base_duration_days, :integer, default: 21
    add_column :work_flows, :translation_days, :integer, default: 15
    add_column :work_flows, :horw_days, :integer, default: 10
  end
end
