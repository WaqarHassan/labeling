class L2 < ActiveRecord::Base
	belongs_to :l1
	has_many :l3s, dependent: :destroy

	has_many :workflow_steps, as: :object
end
