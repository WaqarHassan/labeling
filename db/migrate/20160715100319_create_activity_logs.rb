class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer :l3_id
      t.datetime :stored_on
      t.integer :user_id
      t.integer :number_of_component
      t.string :updated_by
      t.string :orignal_value

      t.timestamps null: false
    end
  end
end
