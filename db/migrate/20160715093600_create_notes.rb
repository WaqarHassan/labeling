class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :l3_id
      t.integer :user_id
      t.text :description

      t.timestamps null: false
    end
  end
end
