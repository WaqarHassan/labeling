class CreateReportFilterSteps < ActiveRecord::Migration
  def change
    create_table :report_filter_steps do |t|
      t.integer :work_flow_id
      t.integer :station_step_id
      t.integer :sequence

      t.timestamps null: false
    end
  end
end
