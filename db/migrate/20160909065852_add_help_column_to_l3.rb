class AddHelpColumnToL3 < ActiveRecord::Migration
  def change
    add_column :l3s, :merge_back_with_id, :integer
    add_column :l3s, :is_main_record, :boolean
  end
end
