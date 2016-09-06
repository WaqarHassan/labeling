class StationStep < ActiveRecord::Base
	belongs_to :workflow_station
	has_many :workflow_live_stations
	has_many :transitions

	def calculate_step_completion(actual_confirmation, comp_attribute_value, lang_attribute_value, hours_per_workday)
		duration_days = self.duration_days
		duration_minutes = self.duration_minutes
		duration_multiplier = self.duration_multiplier
		comp = 1
		lang = 1

		if comp_attribute_value.present?
			comp = comp_attribute_value.num_component.present? ? comp_attribute_value.num_component : 1
			comp = comp.to_i
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
	end
	
end
