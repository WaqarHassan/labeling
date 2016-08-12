class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string  :label
      t.string  :short_label
      t.string  :recording_level
      t.boolean :is_required
      t.boolean :is_visible
	    t.integer :work_flow_id
      t.string  :field_type

      t.timestamps null: false
    end
  end
end
