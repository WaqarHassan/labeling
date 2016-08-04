class Step < ActiveRecord::Base
	has_many :templates
	has_many :transitions
end
