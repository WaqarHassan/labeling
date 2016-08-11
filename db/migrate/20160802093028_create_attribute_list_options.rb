class CreateAttributeListOptions < ActiveRecord::Migration
  def change
    create_table :attribute_list_options do |t|
      t.string :value
      t.integer :attribute_list_id

      t.timestamps null: false
    end
  end
end
