class CreateTimestamplogs < ActiveRecord::Migration
  def change
    create_table :timestamplogs do |t|
      t.integer :workflow_live_step_id
      t.datetime :eta
      t.datetime :actual_confirmation
      t.integer :user_id
      t.integer :no_of_comp
      t.integer :no_of_lang
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
