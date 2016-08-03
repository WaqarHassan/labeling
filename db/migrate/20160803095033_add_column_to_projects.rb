class AddColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :work_flow_id, :integer
  end
end
