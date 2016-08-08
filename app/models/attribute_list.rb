class AttributeList < ActiveRecord::Base
	has_many :attribute_list_values
	belongs_to :work_flow
end
