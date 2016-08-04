class CreateWorkflowAttributes < ActiveRecord::Migration
  def change
    create_table :workflow_attributes do |t|
      t.string :label1_name
      t.string :label1_attributes
      t.string :label2_name
      t.string :label2_attributes
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
