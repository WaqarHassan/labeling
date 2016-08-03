class CreateWorkFlows < ActiveRecord::Migration
  def change
    create_table :work_flows do |t|
      t.string :name
      t.text :description
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
