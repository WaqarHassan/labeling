class Ecr < ActiveRecord::Base
	belongs_to :ia
	has_many :workflow_steps, as: :object
end
