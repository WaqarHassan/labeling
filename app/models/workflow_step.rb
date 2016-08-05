class WorkflowStep < ActiveRecord::Base
	belongs_to :project
	belongs_to :object, polymorphic: true
end
