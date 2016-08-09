class WorkflowLabelAttribute < ActiveRecord::Base
	belongs_to :workflow_label
	belongs_to :attribute_list
end
