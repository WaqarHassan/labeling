class CreateWorkflowLiveSteps < ActiveRecord::Migration
  def change
    create_table :workflow_live_steps do |t|
      t.integer :station_step_id
      t.integer :object_id
      t.string :object_type
      t.datetime :actual_confirmation
      t.datetime :step_completion
      t.datetime :eta
      t.boolean :is_active
      
      

      t.timestamps null: false
    end
  end
end
