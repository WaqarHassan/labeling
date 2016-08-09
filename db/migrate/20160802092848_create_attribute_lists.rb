class CreateAttributeLists < ActiveRecord::Migration
  def change
    create_table :attribute_lists do |t|
      t.string :label
      t.string :short_label
	  t.integer :work_flow_id
      t.string  :level
      t.string :field_type

      t.timestamps null: false
    end
  end
end
