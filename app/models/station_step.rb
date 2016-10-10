class StationStep < ActiveRecord::Base
	belongs_to :workflow_station
	has_many :workflow_live_stes
	has_many :transitions
	has_many :report_filter_steps
 
 	#
    # * *Parameters* :
    #   - workflow_live_step, actual-confirmation, current_level_objects, lang_attribute_value, hours_per_workday.
    # * *Returns* :
    #   - actual_confirmation and remaining minutes in current hour.
    # * *Description* :
    #   - It calculates Step Compeletion Date of next Station Step based on given Parameters.
    # 
	def calculate_step_completion(live_step, actual_confirmation, level_object, lang_attribute_value, hours_per_workday)
		duration_days = self.duration_days
		duration_minutes = self.duration_minutes
		duration_multiplier = self.duration_multiplier
		comp = 1
		lang = 1

		if level_object.present?
			rework_components = 0
		    if level_object.class.name == 'L3'
		    	if level_object.num_component.to_i > 0
		    		comp = level_object.num_component.to_i - level_object.num_component_in_rework.to_i
		    	end
			else
				comp = level_object.num_component.present? ? level_object.num_component : 1
			end
		end

		if lang_attribute_value.present?
			lang = lang_attribute_value.value.present? ? lang_attribute_value.value : 1
			lang = lang.to_i
		end
		
		numberDays = duration_days.present? ? duration_days : 0
		numberMinute = duration_minutes.present? ? duration_minutes : 0

						# Duration Multiplier
		if duration_multiplier == 'C'
			number_days = numberDays*comp
			number_minutes = numberMinute*comp
		elsif duration_multiplier == 'L'
			number_days = (numberDays*comp)/lang
			number_minutes = (numberMinute*comp)/lang
		else
			number_days = numberDays
			number_minutes = numberMinute
		end

		if !live_step.is_active?
			number_days = 0
			number_minutes = 0
		end

						# Covnert minutes to hours and minutes
		hours_frm_minutes, reminaing_minutes = number_minutes.divmod(60)
		days_frm_hours, remaining_hours = hours_frm_minutes.divmod(hours_per_workday)
		number_days = number_days + days_frm_hours

		actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
		actual_confirmationTime = Time.parse(actual_confirmation)
		actual_confirmation_time =  remaining_hours.business_hours.after(actual_confirmationTime)
		
		if number_days > 0
			actual_confirmation_time =  number_days.business_days.after(actual_confirmation_time)
		end
		
		return  actual_confirmation_time + reminaing_minutes.minutes

		# end_of_day = workflow.end_of_day.to_time.strftime( "%I %M %p" )
		# calculated_end_of_day = actual_confirmation_time + reminaing_minutes.minutes
		# if calculated_end_of_day > end_of_day
		# 	extra_seconds = calculated_end_of_day.to_time.strftime( "%I %M %p" ) - end_of_day.to_time.strftime( "%I %M %p" ))
		# 	extra_minutes = extra_seconds/3600
		# 	actual_confirmation = actual_confirmation_time + reminaing_minutes.minutes
		# 	actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
		# 	actual_confirmationTime = Time.parse(actual_confirmation)
		# 	actual_confirmation_time =  0.business_hours.after(actual_confirmationTime)
		# 	return actual_confirmation_time + extra_minutes
		# else
		# 	return calculated_end_of_day
		# end
	end

	class << self
		#
	    # * *Parameters* :
	    #   - Station Step's Predessors list.
	    # * *Returns* :
	    #   - formated string of Predecessor calculation procedure for current Station Step heading.
	    # * *Description* :
	    #   - It creates a string that is displayed as Station Step heading to show how ETA calculations are done.
	    #
		def get_step_predecessors(predecessors)
			pred_name = "\n" 
			if predecessors.present?
				predecessors_list = predecessors.split(',')
				if predecessors_list.presence
					predecessors_list.each do |pred|
						pred_station_step = StationStep.eager_load(:workflow_station).find_by_id(pred)
						pred_name = pred_name+'*'+pred_station_step.workflow_station.station_name+' - '+pred_station_step.step_name
						pred_name = pred_name+"\n"
					end
				end	
			end	
			return pred_name
		end
	end
	
end

