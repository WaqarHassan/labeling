class L3 < ActiveRecord::Base

	belongs_to :l2
	has_many :workflow_steps, as: :object
	validates :name, uniqueness: true

end
