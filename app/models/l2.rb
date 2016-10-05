class L2 < ActiveRecord::Base
	belongs_to :l1
	has_many :l3s, dependent: :destroy

	has_many :workflow_live_steps, as: :object
	has_many :activity_logs, as: :object
	has_many :attribute_values, as: :object
	has_many :additional_info, as: :object
	has_many :timestamp_logs, -> { order 'actual_confirmation desc' }, through: :workflow_live_steps

	validates :name, uniqueness: {:message => "must be unique!" }

  def get_searched_l3_objects(l3_list)
  	L3.where(id: [l3_list], l2_id: self.id)
  end

  def get_workflow_live_steps(filter_stations)
    self.workflow_live_steps.where("station_step_id in (#{filter_stations})")
  end

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

  def get_num_lang
  	num_lang_value = ''
  	num_lang = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
  	if num_lang.present?
  		num_lang_value = num_lang.value
  	end	
  	return num_lang_value
  end

  def get_comp_type
  	comp_type_value = ''
  	comp_type = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label like '%Comp Type%'").first
  	if comp_type.present?
  		comp_type_value = comp_type.value
  	end	
  	return comp_type_value
  end

  def get_horw
  	horw_value = ''
  	horw = self.attribute_values.joins(:label_attribute).where("label_attributes.short_label='Horw'").first
  	if horw.present?
  		horw_value = horw.value
  	end	
  	return horw_value
  end

end
