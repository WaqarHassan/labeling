class ReportsController < ApplicationController
	skip_authorization_check

	def index
	end

	def entire_history
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post?
			@task_confirmation = false
			serach_result = search
			if serach_result.present?
				l2_name = ''
				l1_name = ''
				l1_list = ''
				@l2_list = ''
				@l3_list = ''
				serach_result.each do |result|
				  	if l1_name != result['l1_name']
				  		l1_name = result['l1_name']
				  		l1_list += result['l1_id'].to_s+'_' 
				  	end

				  	if l2_name != result['l2_name'] && result['l2_id'].presence
				  		l2_name = result['l2_name']
				  		@l2_list += result['l2_id'].to_s+'_' 
				  	end	

				  	if result['l3_id'].presence
				  		@l3_list += result['l3_id'].to_s+'_' 
				  	end	
			  	end

			  	l1_list = l1_list.split('_')
				@l2_list = @l2_list.split('_')
			    @l3_list = @l3_list.split('_')
				@report_l1s = L1.where(id: [l1_list])

				@report_l1s.each do |l1|
					if l1.timestamp_logs.present?
						@task_confirmation = true
					end
					@l2_list_objects = l1.l2s.where(id: [@l2_list])
					@l2_list_objects.each do |l2|
						if l2.timestamp_logs
							@task_confirmation = true
						end
							@l3_list_objects = l2.l3s.where(id: [@l3_list])
							@l3_list_objects.each do |l3|
								if l3.timestamp_logs
									@task_confirmation = true
								end
							end	
					end
				end	
			end
		end
	end
	def current_status
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post?
			serach_result = search
			if serach_result.present?
				l2_name = ''
				l1_name = ''
				l1_list = ''
				@l2_list = ''
				@l3_list = ''
				serach_result.each do |result|
				  	if l1_name != result['l1_name']
				  		l1_name = result['l1_name']
				  		l1_list += result['l1_id'].to_s+'_' 
				  	end	
				  	if l2_name != result['l2_name'] && result['l2_id'].presence
				  		l2_name = result['l2_name']
				  		@l2_list += result['l2_id'].to_s+'_' 
				  	end
				  	if result['l3_id'].presence
				  		@l3_list += result['l3_id'].to_s+'_' 
				  	end		
			  	end
			    l1_list = l1_list.split('_')
				@l2_list = @l2_list.split('_')
			    @l3_list = @l3_list.split('_')
				@report_l1s = L1.where(id: [l1_list])
			end
		end
	end
	def daily_activity
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post?
			date = L1.set_db_date_format(params[:daily_report_date])
			@logs = TimestampLog.where("STR_TO_DATE( '#{date}', '%Y-%m-%d') = STR_TO_DATE(created_at, '%Y-%m-%d')")
		end
	end
	def handoff
		@task_confirmation = true
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post?
			@filter_stations = '1,7,5,17,19'
			@filtered_station_steps = StationStep.where("id in (#{@filter_stations})").order(:sequence)
			@entir_history = []
			@task_confirmation = false
			@l1s_name = []
			serach_result = search
			if serach_result.present?
				l2_name = ''
				l1_name = ''
				l1_list = ''
				@l2_list = ''
				@l3_list = ''
				serach_result.each do |result|
				  	if l1_name != result['l1_name']
				  		l1_name = result['l1_name']
				  		l1_list += result['l1_id'].to_s+'_' 
				  	end

				  	if l2_name != result['l2_name'] && result['l2_id'].presence
				  		l2_name = result['l2_name']
				  		@l2_list += result['l2_id'].to_s+'_' 
				  	end	

				  	if result['l3_id'].presence
				  		@l3_list += result['l3_id'].to_s+'_' 
				  	end	
			  	end

			  	l1_list = l1_list.split('_')
				@l2_list = @l2_list.split('_')
			    @l3_list = @l3_list.split('_')
				@report_l1s = L1.where(id: [l1_list])
			end
		end
	end
  	private

		def search 
			q_string = '';
		    session[:report_wildcard] = params[:wildcard]
		    session[:report_exact] = params[:exact]
		    wildcard_bu = params[:wildcard][:business_unit]
		    if wildcard_bu.presence
		      q_string += "(l1s.business_unit like '%#{wildcard_bu}%'"
		      q_string += "OR l2s.business_unit like '%#{wildcard_bu}%'"
		      q_string += "OR l3s.business_unit like '%#{wildcard_bu}%')"
		    end
		    wildcard_l1 = params[:wildcard][:l1]
		    if wildcard_l1.presence
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "l1s.name like '%#{wildcard_l1}%'"
		    end
		    wildcard_l2 = params[:wildcard][:l2]
		    if wildcard_l2.presence
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "l2s.name like '%#{wildcard_l2}%'"
		    end
		    wildcard_l3 = params[:wildcard][:l3]
		    if wildcard_l3.presence
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "l3s.name like '%#{wildcard_l3}%'"
		    end

		    exact_bu = params[:exact][:business_unit]
		    if exact_bu.presence
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "(l1s.business_unit = '#{exact_bu}'"
		      q_string += "OR l2s.business_unit = '#{exact_bu}'"
		      q_string += "OR l3s.business_unit = '#{exact_bu}')"
		    end
		  
		    exact_l2 = params[:exact][:l2]
		    if exact_l2.presence
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "l2s.name = '#{exact_l2}'"
		    end
		    
		    if @workflow.id.presence && q_string != ''
		      q_string += q_string != '' ? ' and ' : ''
		      q_string += "l1s.work_flow_id = "+ @workflow.id.to_s
		    end
		    session[:report_q_string] = q_string
		    if q_string != ''
		      serach_result = WorkFlow.search(q_string)
		    end

		    return serach_result
		end	

end
