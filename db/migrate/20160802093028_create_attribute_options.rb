class CreateAttributeOptions < ActiveRecord::Migration
  def change
    create_table :attribute_options do |t|
      t.string :value
      t.integer :attribute_id

      t.timestamps null: false
    end
  end
end
