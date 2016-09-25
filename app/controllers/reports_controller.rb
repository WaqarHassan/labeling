class ReportsController < ApplicationController
	skip_authorization_check

	def index
	end

	def entire_history_aaaa
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

		if request.post? or session[:report_q_string].present?
			@task_confirmation = false
			if request.post?
				serach_result = search
			else
			  	q_string = session[:report_q_string]
				serach_result = WorkFlow.search(q_string)
			end	

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
	def entire_history
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

		if request.post? or session[:report_q_string].present?
			@task_confirmation = false
			if request.post?
				@serach_result = search[0]
				@report_serach_result = WorkFlow.report_search(search[1])
			else
			  	q_string = session[:report_q_string]
				@serach_result = WorkFlow.search(q_string)
				@report_serach_result = WorkFlow.report_search(q_string)
			end	

			# if @serach_result.present?
			# 	l2_name = ''
			# 	l1_name = ''
			# 	l1_list = ''
			# 	l2_list = ''
			# 	l3_list = ''
			# 	@serach_result.each do |result|
			# 	  	if l1_name != result['l1_name']
			# 	  		l1_name = result['l1_name']
			# 	  		l1_list += result['l1_id'].to_s+'_' 
			# 	  	end

			# 	  	if l2_name != result['l2_name'] && result['l2_id'].presence
			# 	  		l2_name = result['l2_name']
			# 	  		l2_list += result['l2_id'].to_s+'_' 
			# 	  	end	

			# 	  	if result['l3_id'].presence
			# 	  		l3_list += result['l3_id'].to_s+'_' 
			# 	  	end	
			#   	end

			#   	@l1_list = l1_list.split('_')
			# 	@l2_list = l2_list.split('_')
			#     @l3_list = l3_list.split('_')
			     @task_confirmation = true
				#@report_l1s = L1.where(id: [l1_list])

				# @report_l1s.each do |l1|
				# 	if l1.timestamp_logs.present?
				# 		@task_confirmation = true
				# 	end
				# 	@l2_list_objects = l1.l2s.where(id: [@l2_list])
				# 	@l2_list_objects.each do |l2|
				# 		if l2.timestamp_logs
				# 			@task_confirmation = true
				# 		end
				# 			@l3_list_objects = l2.l3s.where(id: [@l3_list])
				# 			@l3_list_objects.each do |l3|
				# 				if l3.timestamp_logs
				# 					@task_confirmation = true
				# 				end
				# 			end	
				# 	end
				# end	
			#end 
		end
	end
	def current_status
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

		if request.post? or session[:report_q_string].present?
			if request.post?
				serach_result = search[0]
				@report_serach_result = WorkFlow.current_report_search(search[1])
			else
			  	q_string = session[:report_q_string]
				@serach_result = WorkFlow.search(q_string)
				@report_serach_result = WorkFlow.current_report_search(q_string)
			end	
			# if serach_result.present?
			# 	l2_name = ''
			# 	l1_name = ''
			# 	l1_list = ''
			# 	@l2_list = ''
			# 	@l3_list = ''
			# 	serach_result.each do |result|
			# 	  	if l1_name != result['l1_name']
			# 	  		l1_name = result['l1_name']
			# 	  		l1_list += result['l1_id'].to_s+'_' 
			# 	  	end	
			# 	  	if l2_name != result['l2_name'] && result['l2_id'].presence
			# 	  		l2_name = result['l2_name']
			# 	  		@l2_list += result['l2_id'].to_s+'_' 
			# 	  	end
			# 	  	if result['l3_id'].presence
			# 	  		@l3_list += result['l3_id'].to_s+'_' 
			# 	  	end		
			#   	end
			#     l1_list = l1_list.split('_')
			# 	@l2_list = @l2_list.split('_')
			#     @l3_list = @l3_list.split('_')
			# 	@report_l1s = L1.where(id: [l1_list])
			# end
		end
	end

	def daily_activity
		@work_flows = WorkFlow.where(is_active: true)
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post? or session[:daily_activity_report_date].present?
			if request.post?
				@daily_report_date = params[:daily_report_date]
				session[:daily_activity_report_date] = @daily_report_date
			else
				@daily_report_date = session[:daily_activity_report_date]
			end
			date = L1.set_db_date_format(@daily_report_date)
			q_string = "STR_TO_DATE( '#{date}', '%Y-%m-%d') = STR_TO_DATE(created_at, '%Y-%m-%d')"
			workflow = params[:work_flow]
			if workflow.present?
				#abort(workflow)
				q_string += "and work_flow_id = #{workflow}"
			else
				q_string += "and work_flow_id = 1"
			end
			@logs = TimestampLog.where(q_string)
		end
	end

	def handoff
		@task_confirmation = true
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

		if request.post? or session[:report_q_string].present?
			#get filter steps from config
			@filtered_steps = ''
			@filtered_station_steps = @workflow.report_filter_steps.order(:sequence)
			if @filtered_station_steps.present?
				@filtered_station_steps.each do |stps|
					@filtered_steps+=  ','+stps.station_step_id.to_s
				end
				if @filtered_steps != ''
					@filtered_steps.slice!(0)
				end
			else	
				@filtered_station_steps = []
			end

			@entir_history = []
			@task_confirmation = false
			@l1s_name = []
			
			if request.post?
				serach_result = search
			else
			  	q_string = session[:report_q_string]
				serach_result = WorkFlow.search(q_string)
			end	

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

		    return [serach_result, q_string] 
		end	

end
