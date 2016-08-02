class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.boolean :is_active
      t.integer :user_id
      t.integer :modified_by_user_id

      t.timestamps null: false
    end
  end
end
