class TimestampLogArchive < ActiveRecord::Base
	belongs_to :user
	belongs_to :work_flow
	belongs_to :workflow_live_step
end
