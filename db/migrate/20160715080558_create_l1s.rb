class CreateL1s < ActiveRecord::Migration
  def change
    create_table :l1s do |t|
      t.string :name
      t.text :description
      t.string :business_unit
      t.integer :work_flow_id
      t.integer :user_id
      t.string :status
      t.integer :modified_by_user_id

      t.timestamps null: false
    end
  end
end
