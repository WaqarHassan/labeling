class AddStationToAdditionalInfos < ActiveRecord::Migration
  def change
    add_column :additional_infos, :station, :string
  end
end
