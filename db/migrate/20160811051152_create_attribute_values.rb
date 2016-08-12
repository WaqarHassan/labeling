class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.integer :attribute_id
      t.string :value
      t.integer :object_id
      t.string :object_type

      t.timestamps null: false
    end
  end
end
