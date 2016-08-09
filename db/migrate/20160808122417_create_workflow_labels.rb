class CreateWorkflowLabels < ActiveRecord::Migration
  def change
    create_table :workflow_labels do |t|
      t.string :label	
      t.string :name
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
