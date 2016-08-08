class WorkFlow < ActiveRecord::Base
	has_many :templates
	has_many :projects
end
