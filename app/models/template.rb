class Template < ActiveRecord::Base
	belongs_to :step
	belongs_to :work_flow
end
