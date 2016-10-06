class AttributeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :label_attribute

	class << self
        # 
        # * *Parameter/Arguments* :
        #   - It accepts lx object , lx object type and an array of attribute parameters
        #     containg id and value.
        # * *Description* :
        #   - It creates multiple attribute value reocrds for respective lx objects's each attribute.
        #
		def create_attribute_values(attr_params, l_object, l_type) 
        	attr_params.each do |att|
         		AttributeValue.create(:label_attribute_id => att[0] ,
                               :value => att[1] ,
                               :object_id => l_object.id ,
                               :object_type => l_type)
        	end 
    	end
        # 
        # * *Parameter/Arguments* :
        #   - It accepts lx object , lx object type,  attribute id and attribute value.
        # * *Description* :
        #   - It creates attribute value record for respective lx objects's.
        #
        def create_single_attribute_value(label_attribute, att_value, l_object, l_type)   
         		AttributeValue.create(:label_attribute_id => label_attribute,
                               :value => att_value ,
                               :object_id => l_object.id ,
                               :object_type => l_type)
        end

	end

end
