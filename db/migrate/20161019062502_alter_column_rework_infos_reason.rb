class AlterColumnReworkInfosReason < ActiveRecord::Migration
  def up
    change_table :rework_infos do |t|
     	t.change :reason, :string
    end
  end
  def down
    change_table :rework_infos do |t|
      t.change :reason, :integer
    end
  end
end
