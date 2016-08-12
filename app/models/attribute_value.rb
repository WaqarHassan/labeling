class AttributeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :attribute
end
