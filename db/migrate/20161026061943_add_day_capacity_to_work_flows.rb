class AddDayCapacityToWorkFlows < ActiveRecord::Migration
  def change
    add_column :work_flows, :day_capacity, :integer, :default => 15
  end
end
