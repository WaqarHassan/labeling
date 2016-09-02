class Transition < ActiveRecord::Base
	belongs_to :station_step, class_name: "StationStep", foreign_key: "station_step_id"
	belongs_to :previous_station_step, class_name: "StationStep", foreign_key: "previous_station_step_id"
end
