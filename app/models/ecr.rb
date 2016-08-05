class Ecr < ActiveRecord::Base

	belongs_to :ia_list
	has_many :workflow_steps, as: :object

end
