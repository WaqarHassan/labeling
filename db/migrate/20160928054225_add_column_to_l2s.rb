class AddColumnToL2s < ActiveRecord::Migration
  def change
    add_column :l2s, :latest_ia_approval_date, :date
  end
end
