class CreateAttributeListValues < ActiveRecord::Migration
  def change
    create_table :attribute_list_values do |t|
      t.string :value
      t.integer :attribute_list_id

      t.timestamps null: false
    end
  end
end
