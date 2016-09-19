class ReportsController < ApplicationController
	skip_authorization_check

	def index
	end

	def entire_history
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)
		if request.post?
			@entir_history = []
			@task_confirmation = false
			@l1s_name = []
			serach_result = search
			if serach_result.present?
				l1_name = ''
				l1_list = ''
				serach_result.each do |result|
				  	if l1_name != result['l1_name']
				  		l1_name = result['l1_name']
				  		l1_list += result['l1_id'].to_s+'_' 
				  	end	
			  	end
				@report_l1s = L1.where(id: [l1_list])

				@report_l1s.each do |l1|
					if l1.timestamp_logs.present?
						@task_confirmation = true
					end	
					l1.l2s.each do |l2|
						if l2.timestamp_logs
							@task_confirmation = true
						end
						l2.l3s.each do |l3|
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
