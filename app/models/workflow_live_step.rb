class WorkflowLiveStep < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :station_step
end
