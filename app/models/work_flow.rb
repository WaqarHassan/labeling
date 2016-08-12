class WorkFlow < ActiveRecord::Base
	has_many :l1s
	has_many :label_attributes
	has_many :workflow_stations
end
