class CreateWorkFlows < ActiveRecord::Migration
  def change
    create_table :work_flows do |t|
      t.string :name
      t.text :description
      t.string :L1
      t.string :L2
      t.string :L3
      t.boolean :is_active
      t.boolean :is_in_use
      t.string :l1_bu
      t.string :l2_bu
      t.string :l3_bu

      t.timestamps null: false
    end
  end
end
