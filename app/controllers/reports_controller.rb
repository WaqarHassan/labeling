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
				session[:params_search] = params 
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
  				session[:params_search] = params 
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
		@workflows = [] #WorkFlow.where(is_active: true, is_in_use: false)
		@holidays = []
		@reason_codes = []
		@days_at_ia_approved = 0
		@days_at_ecr_inbox = 0
		@days_at_sent_to_collab = 0
		@days_at_station8_sent = 0
		@days_at_crb_started = 0
		@days_at_ecn_released = 0

		@pred_of_ia_approved = ''
		@pred_of_ecr_inbox = ''
		@pred_of_sent_to_collab = ''
		@pred_of_station8_sent = ''
		@pred_of_crb_started = ''
		@pred_of_ecn_released = ''


		@workflow.holidays.each do |holiday|
	       @holidays << holiday
	    end

		workflows = WorkFlow.where(is_active: true, is_in_use: false)
		workflows.each do |wk|
			@workflows << wk
		end

		@filtered_station_steps = []
	    filtered_station_steps = @workflow.report_filter_steps.eager_load(:station_step => [:workflow_station]).order(:sequence)
		filtered_station_steps.each do |fss|
			@filtered_station_steps << fss
			if fss.station_step_id == 1
				@days_at_ia_approved = fss.duration_days
				@pred_of_ia_approved = fss.predecessors
			end
			if fss.station_step_id == 7
				@days_at_ecr_inbox = fss.duration_days
				@pred_of_ecr_inbox = fss.predecessors
			end
			if fss.station_step_id == 5
				@days_at_sent_to_collab = fss.duration_days
				@pred_of_sent_to_collab = fss.predecessors
			end
			if fss.station_step_id == 15
				@days_at_station8_sent = fss.duration_days
				@pred_of_station8_sent = fss.predecessors
			end
			if fss.station_step_id == 17
				@days_at_crb_started = fss.duration_days
				@pred_of_crb_started = fss.predecessors
			end
			if fss.station_step_id == 19
				@pred_of_ecn_released = fss.predecessors
			end

		end

		@stationSteps = []
		station_steps = StationStep.eager_load(:workflow_station)
		station_steps.each do |stp|
			@stationSteps << stp
		end

    	if request.post?
    		params_list = params
    		search
    		session[:report_wildcard] = params[:wildcard]
		    session[:report_exact] = params[:exact]

    		session[:params_search] = params_list 
  			search_parm = search_csv(params_list)
  		else
  			params_list = session[:params_search]
		    if session[:report_wildcard].present?
		      @wildcard = session[:report_wildcard]
		    end
		    if session[:report_exact].present?
		      @exact = session[:report_exact]
		    end

		    if params_list.present?
  				search_parm = search_csv(params_list)
  			end
  		end	

  		if params_list.present?
	  		bu = search_parm[0]
	  		l1 = search_parm[1]
	  		l2 = search_parm[2]
	  		l3 = search_parm[3]
			
			if params_list[:report_include_canceled].presence
	    		include_cancel = true
	    		@report_include_canceled = 'report_include_canceled'
	    	else
	    		include_cancel = false
	    	end
	    	if params_list[:report_include_onhold].presence
	    		include_onhold = true
	    		@report_include_onhold = 'report_include_onhold'
	    	else
	    		include_onhold = false
	    	end
			if params_list[:report_include_completed].presence
	    		include_completed = true
	    		@report_include_completed = 'report_include_completed'
	    	else
	    		include_completed = false
	    	end	

			puts "----:#{bu}---: #{l1}---:#{l2}---:#{l3}----:#{include_cancel}----:#{include_onhold}----:#{include_completed}"
	  		@serach_result = []
	  		serach_result = WorkFlow.handoff_report_stored_procedure(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
  			serach_result.each do |result|
  				@serach_result << result
  			end

  		end
  	end

  	def handoff_new
		@workflows = [] #WorkFlow.where(is_active: true, is_in_use: false)
		@holidays = []
		@reason_codes = []
		@days_at_ia_approved = 0
		@days_at_ecr_inbox = 0
		@days_at_sent_to_collab = 0
		@days_at_station8_sent = 0
		@days_at_crb_started = 0
		@days_at_ecn_released = 0

		@pred_of_ia_approved = ''
		@pred_of_ecr_inbox = ''
		@pred_of_sent_to_collab = ''
		@pred_of_station8_sent = ''
		@pred_of_crb_started = ''
		@pred_of_ecn_released = ''


		@workflow.holidays.each do |holiday|
	       @holidays << holiday
	    end

		workflows = WorkFlow.where(is_active: true, is_in_use: false)
		workflows.each do |wk|
			@workflows << wk
		end

		@filtered_station_steps = []
	    filtered_station_steps = @workflow.report_filter_steps.eager_load(:station_step => [:workflow_station]).order(:sequence)
		filtered_station_steps.each do |fss|
			@filtered_station_steps << fss
			if fss.station_step_id == 1
				@days_at_ia_approved = fss.duration_days
				@pred_of_ia_approved = fss.predecessors
			end
			if fss.station_step_id == 7
				@days_at_ecr_inbox = fss.duration_days
				@pred_of_ecr_inbox = fss.predecessors
			end
			if fss.station_step_id == 5
				@days_at_sent_to_collab = fss.duration_days
				@pred_of_sent_to_collab = fss.predecessors
			end
			if fss.station_step_id == 15
				@days_at_station8_sent = fss.duration_days
				@pred_of_station8_sent = fss.predecessors
			end
			if fss.station_step_id == 17
				@days_at_crb_started = fss.duration_days
				@pred_of_crb_started = fss.predecessors
			end
			if fss.station_step_id == 19
				@pred_of_ecn_released = fss.predecessors
			end

		end

		@stationSteps = []
		station_steps = StationStep.eager_load(:workflow_station)
		station_steps.each do |stp|
			@stationSteps << stp
		end

    	if request.post?
    		params_list = params
    		search
    		session[:report_wildcard] = params[:wildcard]
		    session[:report_exact] = params[:exact]

    		session[:params_search] = params_list 
  			search_parm = search_csv(params_list)
  		else
  			params_list = session[:params_search]
		    if session[:report_wildcard].present?
		      @wildcard = session[:report_wildcard]
		    end
		    if session[:report_exact].present?
		      @exact = session[:report_exact]
		    end

		    if params_list.present?
  				search_parm = search_csv(params_list)
  			end
  		end	

  		if params_list.present?
	  		bu = search_parm[0]
	  		l1 = search_parm[1]
	  		l2 = search_parm[2]
	  		l3 = search_parm[3]
			
			if params_list[:report_include_canceled].presence
	    		include_cancel = true
	    		@report_include_canceled = 'report_include_canceled'
	    	else
	    		include_cancel = false
	    	end
	    	if params_list[:report_include_onhold].presence
	    		include_onhold = true
	    		@report_include_onhold = 'report_include_onhold'
	    	else
	    		include_onhold = false
	    	end
			if params_list[:report_include_completed].presence
	    		include_completed = true
	    		@report_include_completed = 'report_include_completed'
	    	else
	    		include_completed = false
	    	end	

			puts "----:#{bu}---: #{l1}---:#{l2}---:#{l3}----:#{include_cancel}----:#{include_onhold}----:#{include_completed}"
	  		@serach_result = []
	  		@serach_result_ho_ia = []
	  		@serach_result_ho_ia2 = []
	  		@serach_result_matched = []
	  		serach_result = WorkFlow.handoff_report_stored_procedure_new(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
	  		serach_result_ho_ia = WorkFlow.handoff_report_ia_stored_procedure(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)

	  		serach_result_ho_ia.each do |ia_result|
	  			@serach_result_ho_ia2 << ia_result
	  		end

  			serach_result.each do |result|
  				project_id = result[31]
  				ia_id = result[32]
  				ia_ho_l2s = @serach_result_ho_ia2.find{|l2s| l2s[10] == project_id and l2s[11] == ia_id}
  				@serach_result_matched << ia_ho_l2s
  				result << ia_ho_l2s[8]
  				result << ia_ho_l2s[9]
  				@serach_result << result
  			end

  			@serach_result_ho_ia2.each do |result_ia|
  				matched_project_id = result_ia[10]
  				matched_ia_id = result_ia[11]
  				ia_ho_l2s = @serach_result_matched.find{|l2s| l2s[10] == matched_project_id and l2s[11] == matched_ia_id}
  				if !ia_ho_l2s.present?
  					to_translation = result_ia[8]
  					if to_translation.downcase != 'n/a' and to_translation[0,3].downcase != 'eta'
  						@serach_result_ho_ia << result_ia
  					end
  				end
  			end
  			  			
  		end
  	end

	
	def handoff_my_query
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

  	def download_handoff_report
  		search_parm = search_csv(params)
  		bu = search_parm[0]
  		l1 = search_parm[1]
  		l2 = search_parm[2]
  		l3 = search_parm[3]
		
		if params[:report_include_canceled] == "report_include_canceled"
    		include_cancel = true
    	else
    		include_cancel = false
    	end
    	if params[:report_include_onhold] == "report_include_onhold"
    		include_onhold = true
    	else
    		include_onhold = false
    	end
		if params[:report_include_completed] == "report_include_completed"
    		include_completed = true
    	else
    		include_completed = false
    	end	

		puts "----:#{bu}---: #{l1}---:#{l2}---:#{l3}----can: #{include_cancel}----on: :#{include_onhold}----comp: #{include_completed}"
  		report_result = WorkFlow.handoff_report_stored_procedure(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
  		csv_file = WorkFlow.to_csv(report_result)

  		send_data csv_file, :filename => 'HAND-OFF-Report.csv'

  	end

	# 
  	# * *Description* :
  	#   - It is a backup function for HandOff 
  	#

  	def download_handoff_report_new
  		search_parm = search_csv(params)
  		bu = search_parm[0]
  		l1 = search_parm[1]
  		l2 = search_parm[2]
  		l3 = search_parm[3]
		
		if params[:report_include_canceled] == "report_include_canceled"
    		include_cancel = true
    	else
    		include_cancel = false
    	end
    	if params[:report_include_onhold] == "report_include_onhold"
    		include_onhold = true
    	else
    		include_onhold = false
    	end
		if params[:report_include_completed] == "report_include_completed"
    		include_completed = true
    	else
    		include_completed = false
    	end	

		puts "----:#{bu}---: #{l1}---:#{l2}---:#{l3}----can: #{include_cancel}----on: :#{include_onhold}----comp: #{include_completed}"
  		report_result = WorkFlow.handoff_report_stored_procedure_new(bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
  		csv_file = WorkFlow.to_csv_new(report_result)

  		send_data csv_file, :filename => 'HAND-OFF-Report-New.csv'

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

	def data_feed
		report_result = WorkFlow.data_feed_stored_procedure()
  		csv_file = WorkFlow.to_csv_data_feed(report_result)
  		respond_to do |format|
  			format.csv { send_data csv_file, :filename => 'DataFeed.csv' }
  		end
	end

	def reject_data
		report_result = WorkFlow.reject_data_stored_procedure()
  		csv_file = WorkFlow.to_csv_reject_data(report_result)
  		respond_to do |format|
  			format.csv { send_data csv_file, :filename => 'RejectData.csv' }
  		end
	end

	def wip
		@workflows = WorkFlow.where(is_active: true, is_in_use: true)
		if request.post?
			@request_type = "post"
			@default_values = [ [L1.set_db_date_format(params[:table1][:start_date]) , L1.set_db_date_format(params[:table1][:end_date])],
								[L1.set_db_date_format(params[:table2][:start_date]), L1.set_db_date_format(params[:table2][:end_date])],
								[L1.set_db_date_format(params[:table3][:start_date]), L1.set_db_date_format(params[:table3][:end_date])],
								[L1.set_db_date_format(params[:table4][:start_date]), L1.set_db_date_format(params[:table4][:end_date])]
							  ]

			table1 = WorkFlow.default_wip_query(
												L1.set_db_date_format( params[:table1][:start_date] ),
												L1.set_db_date_format( params[:table1][:end_date] )
												)
			
			table2 = WorkFlow.default_wip_query(
												L1.set_db_date_format(params[:table2][:start_date]),
												L1.set_db_date_format(params[:table2][:end_date])
												)
			table3 = WorkFlow.default_wip_query(
												L1.set_db_date_format(params[:table3][:start_date]),
												L1.set_db_date_format(params[:table3][:end_date])
												)
			table4 = WorkFlow.default_wip_query(
												L1.set_db_date_format(params[:table4][:start_date]),
												L1.set_db_date_format(params[:table4][:end_date])
												)
			@day_capacity = [params[:table1][:day_capacity],params[:table2][:day_capacity],
							params[:table3][:day_capacity],params[:table4][:day_capacity]]
			@all_data = [table1.first ,table2.first , table3.first , table4.first]

			@target_days = @all_data[0][0..8]

			respond_to do |format|
				format.js
				format.html
			end

		end

		@all_data = WorkFlow.default_wip()[0..4]	#quality check [0..4] need to done by waqar
		@default_values = @all_data[0]
		@target_days = @all_data[1][0..8]
		@all_data = @all_data[1..4]
	end

	def throughput_detail
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		checkpoints = ['APPROVED','TRANSLATION','STATION4','FROMCOLLAB','STATION7','STATION8','TOCRB','FROMCRB','RELEASE']

    if request.post?
      start_date = params[:start_date]
      end_date = params[:end_date]
      check_point = checkpoints[params[:check_point_index].to_i]

      @object_type = 'L3'
      if check_point == 'APPROVED' or check_point == 'TRANSLATION'
        @object_type = 'L2'
      end

      @throughput_details = WorkFlow.get_throughput_detail(start_date, end_date, check_point)
    else
      @throughput_details = nil
      @alert_sms = "Please click on hyperlink from WIP report to send params and get detail"
    end

	end

	def wip_detail
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		checkpoints = ['APPROVED','TRANSLATION','STATION4','FROMCOLLAB','STATION7','STATION8','TOCRB','FROMCRB','RELEASE']

    if request.post?
      end_date = params[:end_date]
      check_point = checkpoints[params[:check_point_index].to_i]

      @object_type = 'L3'
      if check_point == 'APPROVED' or check_point == 'TRANSLATION'
        @object_type = 'L2'
      end

      @wip_details = WorkFlow.get_wip_detail(end_date, check_point)
    else
      @wip_details = nil
      @alert_sms = "Please click on hyperlink from WIP report to send params and get detail"
    end
	end

	def rework_info
		@workflows = WorkFlow.where(is_active: true, is_in_use: true)
		if request.post?
			start_date = L1.set_db_date_format( params[:start_date] )
			end_date = L1.set_db_date_format( params[:end_date] )
			@rework_info_report_data = WorkFlow.rework_info_report_query(start_date,end_date)

		end
		respond_to do |format|
				format.js
				format.html
		end

	end
	def rework_info_backup
		@workflows = WorkFlow.where(is_active: true, is_in_use: true)
		if request.post?
			#abort( params[:start_date].to_s)
			start_date = L1.set_db_date_format( params[:start_date] )
			end_date = L1.set_db_date_format( params[:end_date] )
			#abort(start_date.to_s)
			@rework_infos_list = []
			@actual_confirmations_list = []
			@parent_l3s = []
			@l3s = []
			@l2s = []
			@parent_reasons = []
			@child_reasons = []
			rework_infos = ReworkInfo.where.not(rework_start_step: nil)
 			rework_infos.each do |rework_info|
				if rework_info.rework_start_step.present?
					ts_log  = TimestampLog.where(workflow_live_step_id: rework_info.rework_start_step ).first
					if ts_log.present?
						if (ts_log.actual_confirmation.strftime('%Y-%m-%d') >= start_date && ts_log.actual_confirmation.strftime('%Y-%m-%d') <= end_date)
							@rework_infos_list << rework_info
							@actual_confirmations_list << ts_log.actual_confirmation
							@parent_l3s << rework_info.object
							@l2s << rework_info.object.l2
							@l3s << L3.find_by_id(rework_info.new_rework_id)
							
							if rework_info.reason_code_values.present?
								children_str = ''
								parents_str = ''
								codes = rework_info.reason_code_values.pluck(:new_reason_code_id)
								codes.each do |code|
									row = NewReasonCode.find_by_id(code)
									if row.parent_id.present?
										children_str += row.reason_code.to_s + ','
									else
										parents_str += row.reason_code.to_s + ','
									end
								end
								@parent_reasons << parents_str.chop
								@child_reasons << children_str.chop
							else
								if rework_info.reason.present?
									parents_str = ''
									codes = rework_info.reason.split(',')
									codes.each do |code|
										row = ReasonCode.find_by_id(code)
										parents_str += row.reason+ ','
									end
									@child_reasons << ''
									@parent_reasons << parents_str.chop
								end
							end
						end
					end
				end

			end
		end
		respond_to do |format|
				format.js
				format.html
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
