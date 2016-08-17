class CreateReworkInfos < ActiveRecord::Migration
  def change
    create_table :rework_infos do |t|
      t.string  :start_rework_station
      t.string  :start_rework_step
      t.integer :user_id
      t.integer :station_id
      t.text    :reason
      t.integer :l1_id
      t.integer :l2_id
      t.integer :l3_id
      t.integer :step_id

      t.timestamps null: false
    end
  end
end
