class LabelAttribute < ActiveRecord::Base
	has_many :attribute_options
	has_many :attribute_values
	belongs_to :work_flow
end
