class AddColumnToWorkFlows < ActiveRecord::Migration
  def change
    add_column :work_flows, :l1_bg_color, :string
  end
end
