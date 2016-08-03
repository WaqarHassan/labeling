class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :work_flow_id
      t.integer :step_id
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
