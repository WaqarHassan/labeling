class CreateAttributeValues < ActiveRecord::Migration
  def change
    create_table :attribute_values do |t|
      t.integer :attribute_list_id
      t.string :value

      t.timestamps null: false
    end
  end
end
