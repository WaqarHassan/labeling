class CreateAdditionalInfos < ActiveRecord::Migration
  def change
    create_table :additional_infos do |t|
      t.string :status
      t.integer :workflow_station_id
      t.datetime :info_timestamp
      t.text :note
      t.integer :reason_code_id
      t.integer :object_id
      t.string :object_type
      t.integer :work_flow_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
