class AttributeList < ActiveRecord::Base
	has_many :attribute_list_values
	has_many :workflow_label_attributes
	belongs_to :work_flow
end
