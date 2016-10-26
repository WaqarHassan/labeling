class AddDayCapacityToWorkFlows < ActiveRecord::Migration
  def change
    add_column :work_flows, :day_capacity, :integer
  end
end
