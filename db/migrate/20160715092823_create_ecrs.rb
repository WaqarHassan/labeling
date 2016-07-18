class CreateEcrs < ActiveRecord::Migration
  def change
    create_table :ecrs do |t|
      t.string :name
      t.integer :user_id
      t.string :status
      t.text :note
      t.integer :station_id
      t.datetime :status_start
      t.integer :rework_of

      t.timestamps null: false
    end
  end
end
