class AddUserIdToReasonCodeValueArchives < ActiveRecord::Migration
  def change
  	 add_column :reason_code_value_archives, :user_id, :integer
  end
end
