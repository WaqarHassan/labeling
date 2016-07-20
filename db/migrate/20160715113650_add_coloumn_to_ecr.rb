class AddColoumnToEcr < ActiveRecord::Migration
  def change
    add_column :ecrs, :ia_id, :integer
  end
end