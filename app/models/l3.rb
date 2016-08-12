class L3 < ActiveRecord::Base

	belongs_to :l2
	has_many :workflow_live_steps, as: :object
	has_many :attribute_values, as: :object
	validates :name, uniqueness: true

end
