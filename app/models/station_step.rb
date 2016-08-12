class StationStep < ActiveRecord::Base
	belongs_to :workflow_station
	has_many :workflow_live_stations
end
