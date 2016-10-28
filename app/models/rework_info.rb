class ReworkInfo < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :user
	has_many :reason_code_values, as: :object 
end
