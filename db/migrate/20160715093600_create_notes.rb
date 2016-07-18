class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :ecr_id
      t.integer :created_by
      t.integer :updated_by
      t.text :description

      t.timestamps null: false
    end
  end
end
