class Step < ActiveRecord::Base
	has_many :template_station_steps
	has_many :transitions
end
