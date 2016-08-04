class CreateWorkflowSteps < ActiveRecord::Migration
  def change
    create_table :workflow_steps do |t|
      t.integer :step_id
      t.integer :object_id
      t.string :object_type
      t.datetime :actual_confirmation
      t.datetime :eta
      t.boolean :is_active
      t.integer :project_id

      t.timestamps null: false
    end
  end
end