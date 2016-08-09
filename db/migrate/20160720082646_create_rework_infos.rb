class CreateReworkInfos < ActiveRecord::Migration
  def change
    create_table :rework_infos do |t|
      t.string :collab_name
      t.datetime :time_stamp
      t.integer :user_id
      t.integer :station_id
      t.text :reason
      t.integer :comp_number
      t.string :type
      t.integer :l3_id

      t.timestamps null: false
    end
  end
end
