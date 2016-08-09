class WorkFlow < ActiveRecord::Base
	has_many :templates
	has_many :projects
	has_many :workflow_labels
	has_many :attribute_lists
end
