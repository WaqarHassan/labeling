class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :status
      t.string :recording_level
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
