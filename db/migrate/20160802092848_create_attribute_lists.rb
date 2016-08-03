class CreateAttributeLists < ActiveRecord::Migration
  def change
    create_table :attribute_lists do |t|
      t.string :label
      t.string :short_label

      t.timestamps null: false
    end
  end
end
