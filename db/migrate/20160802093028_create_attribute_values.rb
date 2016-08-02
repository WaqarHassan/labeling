class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.string :value
      t.integer :attribute_id

      t.timestamps null: false
    end
  end
end
