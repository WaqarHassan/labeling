class AttributeList < ActiveRecord::Base
	has_many :attribute_list_options
	has_many :workflow_label_attributes
	belongs_to :work_flow
end
