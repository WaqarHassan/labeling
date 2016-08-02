class AddColumnToIa < ActiveRecord::Migration
  def change
    add_column :ia, :translation, :boolean
  end
end
