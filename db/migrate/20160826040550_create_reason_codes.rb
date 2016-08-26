class CreateReasonCodes < ActiveRecord::Migration
  def change
    create_table :reason_codes do |t|
      t.string :reason
      t.string :status
      t.string :recording_level
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
