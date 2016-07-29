class CreateIa < ActiveRecord::Migration
  def change
    create_table :ia do |t|
      t.string :name
      t.boolean :translation
      t.boolean :horw
      t.datetime :inbox_date
      t.datetime :sent_date
      t.datetime :received_date

      t.timestamps null: false
    end
  end
end
