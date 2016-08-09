class AddColumnToL1s < ActiveRecord::Migration
  def change
    add_column :l1s, :work_flow_id, :integer
  end
end
