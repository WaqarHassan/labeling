class AddNoteToReworkInfo < ActiveRecord::Migration
  def change
    add_column :rework_infos, :note, :text
  end
end
