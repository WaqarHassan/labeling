class L3 < ActiveRecord::Base

	belongs_to :l2
	has_many :workflow_live_steps, as: :object
	has_many :attribute_values, as: :object
	validates :name, uniqueness: {:message => "must be unique!" }
	has_many :additional_info, as: :object
	has_many :timestamp_logs, through: :workflow_live_steps


	def get_farthest_to_the_right_confirmation(l3_id)

		wf_live_step = L3.find_by_id(l3_id).workflow_live_steps.where.not( actual_confirmation: nil).order('id DESC').first

			if !wf_live_step.present?
				wf_live_step = L3.find_by_id(l3_id).workflow_live_steps.first

			end
					
			return wf_live_step
	end

end
