class WorkflowStation < ActiveRecord::Base
	belongs_to :work_flow
	has_many :station_steps
	has_many :additional_info
end
