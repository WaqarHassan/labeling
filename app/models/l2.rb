class L2 < ActiveRecord::Base
	belongs_to :l1
	has_many :l3s, dependent: :destroy

	has_many :workflow_live_steps, as: :object
	has_many :activity_logs, as: :object
	has_many :attribute_values, as: :object
	has_many :additional_info, as: :object
	has_many :timestamp_logs, -> { order 'actual_confirmation desc' }, through: :workflow_live_steps

	validates :name, uniqueness: {:message => "must be unique!" }
end
