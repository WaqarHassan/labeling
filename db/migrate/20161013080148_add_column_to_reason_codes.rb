class AddColumnToReasonCodes < ActiveRecord::Migration
  def change
    add_column :reason_codes, :sequence, :integer
  end
end
