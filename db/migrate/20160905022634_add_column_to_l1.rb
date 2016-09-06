class AddColumnToL1 < ActiveRecord::Migration
  def change
    add_column :l1s, :num_component, :integer
  end
end
