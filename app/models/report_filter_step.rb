class ReportFilterStep < ActiveRecord::Base
	belongs_to :work_flow
	belongs_to :station_step
end
