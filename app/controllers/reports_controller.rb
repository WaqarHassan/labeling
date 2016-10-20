class ReportsController < ApplicationController
	skip_authorization_check
	# 
  	# * *Description* :
  	#   - Its does nothing
  	#
	def index
	end
 	# 
  	# * *Description* :
  	#   - It gets Entire History data of given Object.
  	#
	def entire_history
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    @report_include_canceled = session[:report_include_canceled]
    	@report_include_completed = session[:report_include_completed]

	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

		if request.post? or session[:report_q_string].present?
			@task_confirmation = false
			q_string = ''
			if request.post?
			    if params[:report_include_canceled].presence
			      @report_include_canceled = params[:report_include_canceled]
			      session[:report_include_canceled] = @report_include_canceled
			    else
			      session.delete(:report_include_canceled)
			    end
			    if params[:report_include_completed].presence
			      @report_include_completed = params[:report_include_completed]
			      session[:report_include_completed] = @report_include_completed
			    else
			      session.delete(:report_include_completed)
			    end

				@serach_result = search[0]
				q_string = search[1]
			else
			  	q_string = session[:report_q_string]
			  	if q_string != ''
					if @report_include_canceled == 'report_include_canceled' and @report_include_completed == 'report_include_completed'
						@serach_result = WorkFlow.search(q_string)
					elsif @report_include_canceled == 'report_include_canceled'
						@serach_result = WorkFlow.search_exclude_complete(q_string)
					elsif @report_include_completed == 'report_include_completed'
						@serach_result = WorkFlow.search_exclude_cancel(q_string)
					else
						@serach_result = WorkFlow.search_exclude_cancel_and_complete(q_string)
					end	
				end
			end

			if q_string != ''
		      if @report_include_canceled == 'report_include_canceled' and @report_include_completed == 'report_include_completed'
		        @report_serach_result = WorkFlow.entire_report_search(q_string)
		      elsif @report_include_canceled == 'report_include_canceled'
		      	@report_serach_result = WorkFlow.entire_report_search_exclude_complete(q_string)
		      elsif @report_include_completed == 'report_include_completed'
		      	@report_serach_result = WorkFlow.entire_report_search_exclude_cancel(q_string)
		      else
		      	@report_serach_result = WorkFlow.entire_report_search_exclude_cancel_and_complete(q_string)
		      end
			end

		end
	end
	# 
  	# * *Description* :
  	#   - It gets Current Status data of given object
  	#
	def current_status
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		@report_include_canceled = session[:report_include_canceled]
    	@report_include_completed = session[:report_include_completed]
	    
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end
	    if request.post? or session[:report_q_string].present?
	    	q_string = ''
  			if request.post?
			    if params[:report_include_canceled].presence
			      @report_include_canceled = params[:report_include_canceled]
			      session[:report_include_canceled] = @report_include_canceled
			    else
			      session.delete(:report_include_canceled)
			    end
			    if params[:report_include_completed].presence
			      @report_include_completed = params[:report_include_completed]
			      session[:report_include_completed] = @report_include_completed
			    else
			      session.delete(:report_include_completed)
			    end

 				@serach_result = search[0]
 				q_string = search[1]
  			else
  			  	q_string = session[:report_q_string]
  			  	if q_string != ''
					if @report_include_canceled == 'report_include_canceled' and @report_include_completed == 'report_include_completed'
						@serach_result = WorkFlow.search(q_string)
					elsif @report_include_canceled == 'report_include_canceled'
						@serach_result = WorkFlow.search_exclude_complete(q_string)
					elsif @report_include_completed == 'report_include_completed'
						@serach_result = WorkFlow.search_exclude_cancel(q_string)
					else
						@serach_result = WorkFlow.search_exclude_cancel_and_complete(q_string)
					end
	  			end
  			end

			if q_string != ''
		      if @report_include_canceled == 'report_include_canceled' and @report_include_completed == 'report_include_completed'
				@report_serach_result = WorkFlow.current_report_search(q_string)
		      elsif @report_include_canceled == 'report_include_canceled'
		      	@report_serach_result = WorkFlow.current_report_search_exclude_complete(q_string)
		      elsif @report_include_completed == 'report_include_completed'
		      	@report_serach_result = WorkFlow.current_report_search_exclude_cancel(q_string)
		      else
		      	@report_serach_result = WorkFlow.current_report_search_exclude_cancel_and_complete(q_string)
		      end
			end
  		end
	end
	# 
  	# * *Description* :
  	#   - It is a backup function for Current Status report
  	#
	def current_status_aaa
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end
	    
		if request.post? or session[:report_q_string].present?
			if request.post?
				@serach_result = search[0]
				if search[1] != ''
					@report_serach_result = WorkFlow.current_report_search(search[1])
				end
			
			else
			  	q_string = session[:report_q_string]
			  	if q_string != ''
					@serach_result = WorkFlow.search(q_string)
					@report_serach_result = WorkFlow.current_report_search(q_string)
				end
			end	
		end
	end
	# 
  	# * *Description* :
  	#   - It gets daily activity data of given object
  	#
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
			q_string = "STR_TO_DATE( '#{date}', '%Y-%m-%d') = STR_TO_DATE(timestamp_logs.created_at, '%Y-%m-%d')"
			workflow = params[:work_flow]
			if workflow.present?     
				@searched_work_flow = workflow
				q_string += "and timestamp_logs.work_flow_id = #{workflow}"
			else
				@searched_work_flow = @workflow.id
				q_string += "and timestamp_logs.work_flow_id = #{@workflow.id}"
			end
			@report_serach_result = WorkFlow.daily_report_serach(q_string)
		end
	end
	# 
  	# * *Description* :
  	#   - It is a backup function for Daily Activity
  	#
	def daily_activity_aaa
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
				q_string += "and work_flow_id = #{workflow}"
			else
				q_string += "and work_flow_id = #{@workflow.id}"
			end
			@logs = TimestampLog.where(q_string)
		end
	end
	# 
  	# * *Description* :
  	#   - It gets HandOff data of given Osbject
  	#
	def handoff
		@task_confirmation = true
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
	    @report_include_canceled = session[:report_include_canceled]
    	@report_include_completed = session[:report_include_completed]
    	@report_include_onhold = session[:report_include_onhold]
    	if @report_include_onhold == 'report_include_onhold'
    		@is_include_onhold = true
    	else
    		@is_include_onhold = false
    	end
		if @report_include_completed == 'report_include_completed'
    		@is_include_completed = true
    	else
    		@is_include_completed = false
    	end		
    	#@report_include_closed = session[:report_include_closed]

	    if session[:report_wildcard].present?
	      @wildcard = session[:report_wildcard]
	    end
	    if session[:report_exact].present?
	      @exact = session[:report_exact]
	    end

	    @filtered_station_steps = @workflow.report_filter_steps.eager_load(:station_step => [:workflow_station]).order(:sequence)
		if request.post? or session[:report_q_string].present?
			q_string = ''
			@task_confirmation = false
			if request.post?
			    if params[:report_include_canceled].presence
			      @report_include_canceled = params[:report_include_canceled]
			      session[:report_include_canceled] = @report_include_canceled
			    else
			      session.delete(:report_include_canceled)
			    end
			    if params[:report_include_completed].presence
			      @report_include_completed = params[:report_include_completed]
			      session[:report_include_completed] = @report_include_completed
			      @is_include_completed = true
			    else
			      session.delete(:report_include_completed)
			      @is_include_completed = false
			    end
				if params[:report_include_onhold].presence
			      @report_include_onhold = params[:report_include_onhold]
			      @is_include_onhold = true
			      session[:report_include_onhold] = @report_include_onhold
			    else
			      @is_include_onhold = false
			      session.delete(:report_include_onhold)
			    end
			    # if params[:report_include_closed].presence
			    #   @report_include_closed = params[:report_include_closed]
			    #   session[:report_include_closed] = @report_include_closed
			    # else
			    #   session.delete(:report_include_closed)
			    # end

				search_hand_off = handoff_search
				@serach_result = search_hand_off[0]
				q_string = search_hand_off[1]
			else
			  	q_string = session[:report_q_string]
  			  	if q_string != ''
	  				@serach_result = WorkFlow.search_handoff_report(q_string)
	  			end
			end

			if q_string != ''
		      if @report_include_canceled == 'report_include_canceled' and @report_include_completed == 'report_include_completed'
				@report_serach_result = WorkFlow.handoff_report_search(q_string, @workflow.id)
		      elsif @report_include_canceled == 'report_include_canceled'
		      	@report_serach_result = WorkFlow.handoff_report_search_exclude_completed(q_string, @workflow.id)
		      elsif @report_include_completed == 'report_include_completed'
		      	@report_serach_result = WorkFlow.handoff_report_search_exclude_canceled(q_string, @workflow.id)
		      else
		      	@report_serach_result = WorkFlow.handoff_report_search_exclude_canceled_completed(q_string, @workflow.id)
		      end
			end

		end
	end
	# 
  	# * *Description* :
  	#   - It is a backup function for HandOff 
  	#

  	def download_handoff_report_data
  		session[:search_csv] = params
	  	respond_to do |format|
	      format.json { render json: {status: 'success', message: 'search cleared'}, status: 200 }
	    end
  	end

  	def download_handoff_report
  		search_params = session[:search_csv]
  		search_parm = search_csv(search_params)
  		bu = search_parm[0]
  		l1 = search_parm[1]
  		l2 = search_parm[2]
  		l3 = search_parm[3]
		
		if search_params[:report_include_canceled].presence
    		include_cancel = true
    	else
    		include_cancel = false
    	end
    	if search_params[:report_include_onhold].presence
    		include_onhold = true
    	else
    		include_onhold = false
    	end
		if search_params[:report_include_completed].presence
    		include_completed = true
    	else
    		include_completed = false
    	end	

		puts "----:#{bu}---: #{l1}---:#{l2}---:#{l3}----:#{include_cancel}----:#{include_onhold}----:#{include_completed}"
  		report_result = WorkFlow.handoff_report_stored_procedure(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
  		respond_to do |format|
	      format.csv { render text: WorkFlow.to_csv(report_result) }
	    end
  	end

	def handoff_aaa
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
				serach_result = search[0]
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
	# 
  	# * *Description* :
  	#   - It is a backup function for Entire History
  	#
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
  	private

		def search 
			q_string = '';
		    session[:report_wildcard] = params[:wildcard]
		    session[:report_exact] = params[:exact]
		    wildcard_bu = params[:wildcard][:business_unit]
    	    
    	    if params[:report_include_canceled].presence
		      report_include_canceled = params[:report_include_canceled]
		    end

		    if params[:report_include_completed].presence
		      report_include_completed = params[:report_include_completed]
		    end

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
		    q_string_return = q_string
		    if q_string != ''
				if report_include_canceled == 'report_include_canceled' and report_include_completed == 'report_include_completed'
					serach_result = WorkFlow.search(q_string)
				elsif report_include_canceled == 'report_include_canceled'
					serach_result = WorkFlow.search_exclude_complete(q_string)
				elsif report_include_completed == 'report_include_completed'
					serach_result = WorkFlow.search_exclude_cancel(q_string)
				else
					serach_result = WorkFlow.search_exclude_cancel_and_complete(q_string)
				end
		    end

		    return [serach_result, q_string_return]
		end	

		def handoff_search
			q_string = '';
		    session[:report_wildcard] = params[:wildcard]
		    session[:report_exact] = params[:exact]
		    wildcard_bu = params[:wildcard][:business_unit]
    	    
    	    if params[:report_include_canceled].presence
		      report_include_canceled = params[:report_include_canceled]
		    end

		    if params[:report_include_completed].presence
		      report_include_completed = params[:report_include_completed]
		    end

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
		    q_string_return = q_string
		    if q_string != ''
				if report_include_canceled == 'report_include_canceled' and report_include_completed == 'report_include_completed'
					serach_result = WorkFlow.search_handoff_report(q_string)
				elsif report_include_canceled == 'report_include_canceled'
					serach_result = WorkFlow.search_handoff_exclude_complete(q_string)
				elsif report_include_completed == 'report_include_completed'
					serach_result = WorkFlow.search_handoff_exclude_cancel(q_string)
				else
					serach_result = WorkFlow.search_handoff_exclude_cancel_and_complete(q_string)
				end
		    end

		    return [serach_result, q_string_return]
		end	

		def search_csv(params_list)
		    wildcard_bu = params_list[:wildcard][:business_unit]
		    if wildcard_bu.presence
		      bu = "%#{wildcard_bu}%"
		    else
		      bu =  '%'
		    end
		    wildcard_l1 = params_list[:wildcard][:l1]
		    if wildcard_l1.presence
		    	l1 = "%#{wildcard_l1}%"
		    else
		    	l1 = '%'
		    end
		    wildcard_l2 = params_list[:wildcard][:l2]
		    if wildcard_l2.presence
		    	l2 = "%#{wildcard_l2}%"
		    else
		    	l2 = '%'
		    end
		    wildcard_l3 = params_list[:wildcard][:l3]
		    if wildcard_l3.presence
		    	l3 = "%#{wildcard_l3}%"
		    else
		    	l3 = '%'
		    end

		    exact_bu = params_list[:exact][:business_unit]
		    if exact_bu.presence
		      bu = "#{exact_bu}"
		    end
		  
		    exact_l2 = params_list[:exact][:l2]
		    if exact_l2.presence
		    	l2 = "#{exact_l2}"
		    end

		    exact_l3 = params_list[:exact][:l3]
		    if exact_l3.presence
		    	l3 = "#{exact_l3}"
		    end

		    return [bu,l1,l2,l3]
		end	

end
