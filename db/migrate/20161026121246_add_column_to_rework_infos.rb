class AddColumnToReworkInfos < ActiveRecord::Migration
  def change
    add_column :rework_infos, :station, :string
  end
end
