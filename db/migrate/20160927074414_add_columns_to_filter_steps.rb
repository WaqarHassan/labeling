class AddColumnsToFilterSteps < ActiveRecord::Migration
  def change
    add_column :report_filter_steps, :duration_days, :integer
    add_column :report_filter_steps, :predecessors, :string 
  end
end
