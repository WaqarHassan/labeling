class AlterColumnAdditionalInfoReasonCodeId < ActiveRecord::Migration
  def up
  	change_table :additional_infos do |t|
  		t.change :reason_code_id, :string
  	end
  end
  def down
  	change_table :additional_infos do |t|
  		t.change :reason_code_id, :integer
  	end
  end
end
