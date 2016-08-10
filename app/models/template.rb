class Template < ActiveRecord::Base
	belongs_to :step
	belongs_to :work_flow
	has_many :template_stations
	has_many :stations, :through => :template_stations
end
