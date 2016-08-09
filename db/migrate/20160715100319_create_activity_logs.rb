class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer :object_id
      t.string :object_type
      t.string :current_value
      t.string :previous_value
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
