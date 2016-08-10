class WorkFlow < ActiveRecord::Base
	has_one :template
	has_many :l1s
	has_many :workflow_labels
	has_many :attribute_lists
end
