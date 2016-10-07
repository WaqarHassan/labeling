class L2 < ActiveRecord::Base
	belongs_to :l1
	has_many :l3s, dependent: :destroy

	has_many :workflow_live_steps, as: :object
	has_many :activity_logs, as: :object
	has_many :attribute_values, as: :object
	has_many :additional_info, as: :object
	has_many :timestamp_logs, -> { order 'actual_confirmation desc' }, through: :workflow_live_steps

	validates :name, uniqueness: {:message => "must be unique!" }
  # 
  # * *Arguments* :
  #   - It accepts a collection of l3s Object ids.
  # * *Description* :
  #   - It gets a list of l3s Object ids and returns complete Objects after quering from database.
  #
  def get_searched_l3_objects(l3_list)
  	L3.where(id: [l3_list], l2_id: self.id)
  end
  # 
  # * *Arguments* :
  #   - It accepts a collection of Station Steps object ids.
  # * *Description* :
  #   - It gets a list of Station Steps Object ids and returns Eorkflow Live Step Objects for current l2s Object.
  #
  def get_workflow_live_steps(filter_stations)
    self.workflow_live_steps.where("station_step_id in (#{filter_stations})")
  end
  # 
  # * *Arguments* :
  #   - Include_canceled , Include_completed.
   # * *Returns* :
  #   - collection of l3s Objects.
  # * *Description* :
  #   - It selects l3s Objetcs based upon parameters.
  #
  def get_l3s_objects(include_canceled, include_completed)

    if include_canceled =='include_canceled' and include_completed == 'include_completed'
      return self.l3s
    elsif include_canceled =='include_canceled'
      return self.l3s.where(completed_actual: nil)
    elsif include_completed == 'include_completed'
      return self.l3s.where.not(status: 'cancel')           
    else 
      return self.l3s.where(completed_actual: nil).where.not(status: 'cancel')
    end
  end
  #
  # * *Description* :
  #   - It returns number of Languages of current Object.
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
  #   - It returns Component type of current Object.
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
  #   - It returns HORW value of current Object.
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
