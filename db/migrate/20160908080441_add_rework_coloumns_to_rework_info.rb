class AddReworkColoumnsToReworkInfo < ActiveRecord::Migration
  def change
    add_column :rework_infos, :move_original_record_back_to_step, :integer
    add_column :rework_infos, :reset_type, :string
    add_column :rework_infos, :new_rework_id, :integer
    add_column :rework_infos, :new_rework_type, :string
  end
end
