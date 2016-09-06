class AddColumnsToWorkFlow < ActiveRecord::Migration
  def change
    add_column :work_flows, :l1_component, :string
    add_column :work_flows, :l2_component, :string, :default => 'Y'
    add_column :work_flows, :l3_component, :string, :default => 'Y|R'
  end
end
