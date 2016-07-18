class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :created_by
      t.integer :updated_by

      t.timestamps null: false
    end
  end
end
