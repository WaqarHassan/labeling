class AddColoumnToAi < ActiveRecord::Migration
  def change
    add_column :ia, :project_id, :integer
  end
end
