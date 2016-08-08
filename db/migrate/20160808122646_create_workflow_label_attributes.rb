class CreateWorkflowLabelAttributes < ActiveRecord::Migration
  def change
    create_table :workflow_label_attributes do |t|
      t.integer :attribute_list_id
      t.boolean :is_required
      t.boolean :is_visible
      t.integer :workflow_label_id

      t.timestamps null: false
    end
  end
end
