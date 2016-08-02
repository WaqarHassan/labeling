class Attribute < ActiveRecord::Base
	has_many :attribute_values
end
