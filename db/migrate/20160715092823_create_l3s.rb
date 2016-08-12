class CreateL3s < ActiveRecord::Migration
  def change
    create_table :l3s do |t|
      t.string :name
      t.integer :business_unit
      t.integer :is_active
      t.text :notes
      t.integer :l2_id
      t.integer :user_id
      t.integer :modified_by_user_id

      t.timestamps null: false
    end
  end
end
