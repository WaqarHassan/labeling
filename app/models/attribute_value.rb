class AttributeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :label_attribute
end
