class CreateBuOptions < ActiveRecord::Migration
  def change
    create_table :bu_options do |t|
      t.string :value
      t.string :recording_level

      t.timestamps null: false
    end
  end
end
