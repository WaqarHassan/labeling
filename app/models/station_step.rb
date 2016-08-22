class StationStep < ActiveRecord::Base
	belongs_to :workflow_station
	has_many :workflow_live_stations

	def calculate_step_completion(actual_confirmation, comp_attribute_value, lang_attribute_value)
		duration_days = self.duration_days
		duration_minutes = self.duration_minutes
		duration_multiplier = self.duration_multiplier
		comp = 1
		lang = 1

		if comp_attribute_value.present?
			comp = comp_attribute_value.value.present? ? comp_attribute_value.value : 1
			comp = comp.to_i
		end
		if lang_attribute_value.present?
			lang = lang_attribute_value.value.present? ? lang_attribute_value.value : 1
			lang = lang.to_i
		end
		
		numberHour = duration_days.present? ? duration_days*8 : 0
		numberMinute = duration_minutes.present? ? duration_minutes : 0

						# Duration Multiplier
		if duration_multiplier == 'C'
			number_hours = numberHour*comp
			number_minutes = numberMinute*comp
		elsif duration_multiplier == 'L'
			number_hours = (numberHour*comp)/lang
			number_minutes = (numberMinute*comp)/lang
		else
			number_hours = numberHour
			number_minutes = numberMinute
		end

						# Covnert minutes to hours and minutes
		minutes_to_hour, reminaing_minutes = number_minutes.divmod(60)
		total_hours = number_hours + minutes_to_hour
		actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
		actual_confirmation_time = Time.parse(actual_confirmation)

		      puts "BBBBBBBBBBBBBBBBBBBB-----#{BusinessTime::Config.beginning_of_workday}"
      		   puts "EEEEEEEEEEEEEEEEEEEE******#{BusinessTime::Config.end_of_workday}"

		actual_confirmationTime =  total_hours.business_hours.after(actual_confirmation_time)

		return  actual_confirmationTime + reminaing_minutes.minutes
	end
	
end
