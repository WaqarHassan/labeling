class CreateIaLists < ActiveRecord::Migration
  def change
    create_table :ia_lists do |t|
      t.string :name
      t.integer :l1_id
      t.string :business_unit
      t.integer :comp_count
      t.text :notes
      t.boolean :is_active
      t.datetime :requested_date
      t.datetime :to_be_approved_by
      t.boolean :translation

      t.timestamps null: false
    end
  end
end
