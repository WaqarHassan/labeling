class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :label
      t.string :short_label

      t.timestamps null: false
    end
  end
end
