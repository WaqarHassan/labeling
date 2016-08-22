class CreateL2s < ActiveRecord::Migration
  def change
    create_table :l2s do |t|
      t.string :name
      t.integer :l1_id
      t.string :status
      t.string :business_unit
      t.text :notes
      t.datetime :requested_date
      t.datetime :to_be_approved_by
      t.integer :user_id
      t.integer :modified_by_user_id
      t.timestamps null: false
    end
  end
end
