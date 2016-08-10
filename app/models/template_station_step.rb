class TemplateStationStep < ActiveRecord::Base
	belongs_to :step
	belongs_to :template_station
end
