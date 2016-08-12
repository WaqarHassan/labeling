class WorkFlow < ActiveRecord::Base
	has_many :l1s
	has_many :attributes
	has_many :workflow_stations
end
