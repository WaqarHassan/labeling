class Ia < ActiveRecord::Base
	belongs_to :project
	has_many :ecrs, dependent: :destroy
	has_many :workflow_steps, as: :imageable
end
