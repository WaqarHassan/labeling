class AddWorkflowCompleteColumnsToLx < ActiveRecord::Migration
  def change
    add_column :l1s, :completed_estimate, :datetime
    add_column :l2s, :completed_estimate, :datetime
    add_column :l3s, :completed_estimate, :datetime

    add_column :l1s, :completed_actual, :datetime
    add_column :l2s, :completed_actual, :datetime
    add_column :l3s, :completed_actual, :datetime
  end
end
