class CreateIa < ActiveRecord::Migration
  def change
    create_table :ia do |t|
      t.string :name
      t.boolean :translation
      t.boolean :horw
      t.date :inbox_date
      t.date :sent_date
      t.date :received_date
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
