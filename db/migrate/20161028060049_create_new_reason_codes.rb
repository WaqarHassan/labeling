class CreateNewReasonCodes < ActiveRecord::Migration
  def change
    create_table :new_reason_codes do |t|
      t.integer :work_flow_id
      t.string :recording_level
      t.string :object
      t.string :reason_code
      t.integer :parent_id
      t.boolean :child_mandatory
      t.integer :sequence

      t.timestamps null: false
    end
  end
end
