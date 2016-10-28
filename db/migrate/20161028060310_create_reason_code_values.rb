class CreateReasonCodeValues < ActiveRecord::Migration
  def change
    create_table :reason_code_values do |t|
      t.integer :object_id
      t.string :object_type
      t.integer :new_reason_code_id

      t.timestamps null: false
    end
  end
end
