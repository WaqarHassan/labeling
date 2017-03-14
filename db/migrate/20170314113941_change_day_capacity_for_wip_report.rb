class ChangeDayCapacityForWipReport < ActiveRecord::Migration
  def change
    workflows = WorkFlow.all
    workflows.each do |workflow|
      workflow.day_capacity = 26
      workflow.save!
    end
  end
end
