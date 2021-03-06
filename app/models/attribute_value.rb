class AttributeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :label_attribute

	class << self
        # 
        # * *Arguments* :
        #   - It accepts lx Object, lx Object type and an array of Attribute Parameters containg id and value.
        #     
        # * *Description* :
        #   - It creates multiple Attribute Value records for respective lxs Objects's each Attribute.
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
        # * *Arguments* :
        #   - It accepts lxs Object, lxs Object type, Attribute Id and Attribute Value.
        # * *Description* :
        #   - It creates Attribute Value record for respective lxs Objects's.
        #
        def create_single_attribute_value(label_attribute, att_value, l_object, l_type)   
         		AttributeValue.create(:label_attribute_id => label_attribute,
                               :value => att_value ,
                               :object_id => l_object.id ,
                               :object_type => l_type)
        end

	end

end
