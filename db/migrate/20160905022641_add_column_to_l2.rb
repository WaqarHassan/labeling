class AddColumnToL2 < ActiveRecord::Migration
  def change
    add_column :l2s, :num_component, :integer
  end
end
