class CreateEcrs < ActiveRecord::Migration
  def change
    create_table :ecrs do |t|
      t.string :name
      t.integer :user_id
      t.integer :comp_number
      t.string :comp_type
      t.string :status
      t.text :note
      t.integer :station_id
      t.datetime :inbox
      t.datetime :completed
      t.datetime :sent_to_collab
      t.datetime :received_frm_collab
      t.datetime :sent_to_legal
      t.datetime :received_frm_legal

      t.timestamps null: false
    end
  end
end
