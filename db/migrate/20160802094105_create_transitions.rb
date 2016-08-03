class CreateTransitions < ActiveRecord::Migration
  def change
    create_table :transitions do |t|
      t.integer :step_id
      t.integer :previous_step_id
      t.float :duration

      t.timestamps null: false
    end
  end
end
