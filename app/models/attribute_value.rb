class AttributeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true
end
