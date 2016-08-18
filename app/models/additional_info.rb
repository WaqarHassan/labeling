class AdditionalInfo < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :workflow_station
	belongs_to :user
	belongs_to :work_flow
end
