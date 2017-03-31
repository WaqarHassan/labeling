class AddIsManualToWorkflowLiveSteps < ActiveRecord::Migration
  def change
    add_column :workflow_live_steps, :is_manual, :boolean, default: false
  end
end
