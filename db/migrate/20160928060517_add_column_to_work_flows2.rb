class AddColumnToWorkFlows2 < ActiveRecord::Migration
  def change
    add_column :work_flows, :base_duration_days, :integer
    add_column :work_flows, :translation_days, :integer
    add_column :work_flows, :horw_days, :integer
  end
end
