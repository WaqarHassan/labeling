class CreateIa < ActiveRecord::Migration
  def change
    create_table :ia do |t|
      t.string :name
      t.boolean :translation
      t.boolean :horw
      t.date :requested_date
      t.date :to_be_approved_by

      t.timestamps null: false
    end
  end
end
