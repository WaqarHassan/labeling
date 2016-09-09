class AddReworkColumnToL3s < ActiveRecord::Migration
  def change
    add_column :l3s, :num_component, :integer
    add_column :l3s, :num_component_in_rework, :integer, :default => nil
    add_column :l3s, :rework_parent_id, :integer, :default => nil
    add_column :l3s, :is_full_rework, :boolean, :default => nil
    add_column :l3s, :is_closed, :boolean, :default => false
  end
end
