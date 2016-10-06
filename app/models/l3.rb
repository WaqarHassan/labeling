class L3 < ActiveRecord::Base

	belongs_to :l2
	has_many :workflow_live_steps, as: :object
	has_many :attribute_values, as: :object
	validates :name, uniqueness: {:message => "must be unique!" }
	has_many :additional_info, as: :object
	has_many :timestamp_logs, through: :workflow_live_steps
  # 
  # * *Description* :
  #   - It calculates value of Actually Confirmed top right Station Step
  # * *Returns* :
  #   -value of Actually Confirmed top right Station Step
  #
	def get_farthest_to_the_right_confirmation
 
		wf_live_step = self.workflow_live_steps.where.not( actual_confirmation: nil).order('workflow_live_steps.id DESC').first

			if !wf_live_step.present?
				wf_live_step = self.workflow_live_steps.first

			end
					
			return wf_live_step
	end
  # 
  # * *Arguments* :
  #   - It accepts a collection of Station Steps Object ids
  # * *Description* :
  #   - It gets a list of Station Steps Object ids and return Workflow Live Step Objects
  #     for current l3s Object.
  #
  def get_workflow_live_steps(filter_stations)
    self.workflow_live_steps.where("station_step_id in (#{filter_stations})")
  end
  #
  # * *Description* :
  #   - It returns number of Languages of current Object
  #
  def get_num_lang
  	num_lang_value = ''
  	num_lang = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
  	if num_lang.present?
  		num_lang_value = num_lang.value
  	end	
  	return num_lang_value
  end
  #
  # * *Description* :
  #   - It returns Component type of current Object
  #
  def get_comp_type
  	comp_type_value = ''
  	comp_type = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label like '%Comp Type%'").first
  	if comp_type.present?
  		comp_type_value = comp_type.value
  	end	
  	return comp_type_value
  end
  #
  # * *Description* :
  #   - It returns HORW value of current Object
  #
  def get_horw
  	horw_value = ''
  	horw = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='Horw'").first
  	if horw.present?
  		horw_value = horw.value
  	end	
  	return horw_value
  end

end
