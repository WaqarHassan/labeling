class CreateEcrs < ActiveRecord::Migration
  def change
    create_table :ecrs do |t|
      t.string :name
      t.integer :comp_count
      t.string :comp_type
      t.integer :language_count
      t.integer :is_active
      t.text :notes
      t.integer :ia_list_id
      t.integer :user_id
      t.integer :modified_by_user_id

      t.timestamps null: false
    end
  end
end
