class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :holiday_date
      t.integer :work_flow_id

      t.timestamps null: false
    end
  end
end
