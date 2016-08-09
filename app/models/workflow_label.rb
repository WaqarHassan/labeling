class WorkflowLabel < ActiveRecord::Base
	belongs_to :work_flow
	has_many :workflow_label_attributes
end
