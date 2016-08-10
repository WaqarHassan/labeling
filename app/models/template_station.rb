class TemplateStation < ActiveRecord::Base
	belongs_to :template
	belongs_to :station
	has_many :template_station_steps
	has_many :steps, :through => :template_station_steps
end
