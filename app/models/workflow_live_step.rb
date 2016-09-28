class WorkflowLiveStep < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :station_step
	has_many :timestamp_logs

    def get_latest_timestamp_log
    	step_timestamp = ''
    	table_td_class = ''
    	if self.is_active?
	    	timestampLog = self.timestamp_logs.order(id: :desc).first
	    	if timestampLog.present?
	    		step_timestamp = timestampLog.actual_confirmation.strftime("%m/%d/%y %I:%M %p")
	    		table_td_class = 'report_actual_confirmation'
	    	else
	    		if self.eta.present?
	    			step_timestamp = self.eta.strftime("%m/%d/%y %I:%M %p")
	    			step_timestamp = 'ETA '+step_timestamp
	    			if DateTime.parse(Time.now.to_s) > DateTime.parse(self.eta.to_s)
						table_td_class = 'report_eta_light_red'
					end
	    		end
	    	end
	    else
	    	step_timestamp = 'N/A'
	    end	

    	return [step_timestamp, table_td_class]	
    end

	class << self

		def get_steps_calculate_eta(workflow_live_step,workflow,current_user)

	  	  BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
	      BusinessTime::Config.end_of_workday = workflow.end_of_workday

	      workflow.holidays.each do |holiday|
	        BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
	      end

	      hours_per_workday = workflow.hours_per_workday.present? ? workflow.hours_per_workday : 1

		  workflow_live_step_for_eta = []
		  workflow_live_step_for_eta_ids = []                     
	      if workflow_live_step.object_type == "L3"
	        parent_l1 = workflow_live_step.object.l2.l1
	      elsif workflow_live_step.object_type == "L2"
	        parent_l1 = workflow_live_step.object.l1
	      elsif workflow_live_step.object_type == "L1"
	        parent_l1 = workflow_live_step.object
	      end

	      l1s_last_live_step = nil
	      l2s_last_live_step = []
	      l3s_last_live_step = {}

	      workflow_live_steps_l1 = WorkflowLiveStep.where(object_id: parent_l1.id, object_type: 'L1').order(:id)
	      l1s_last_live_step = workflow_live_steps_l1.last
	      workflow_live_steps_l1.each do |wls_l1|  
	        workflow_live_step_for_eta_ids << wls_l1
	      end
	      
	      parent_l1.l2s.each do |l2|
	        workflow_live_steps_l2 = WorkflowLiveStep.where(object_id: l2.id, object_type: 'L2').order(:id)
	        l2s_last_live_step << workflow_live_steps_l2.last
	        workflow_live_steps_l2.each do |wls_l2|  
	          workflow_live_step_for_eta_ids << wls_l2
	        end

	        l3sLastLiveStep = []
	        l2.l3s.each do |l3|
	          workflow_live_steps_l3 = WorkflowLiveStep.where(object_id: l3.id, object_type: 'L3').order(:id)
	          if !l3.is_closed
	          	l3sLastLiveStep << workflow_live_steps_l3.last
	      	  end
	          workflow_live_steps_l3.each do |wls_l3|  
	            workflow_live_step_for_eta_ids << wls_l3
	          end
	        end
	        l3s_last_live_step[l2.id] = l3sLastLiveStep
	      end
	     
	      workflow_live_step_for_eta_ids = workflow_live_step_for_eta_ids.sort_by{|wls_sort| wls_sort.id} 
	      first_step = workflow_live_step_for_eta_ids.first
	      last_step = workflow_live_step_for_eta_ids.last

	      live_steps_qry = "select station_steps.step_name, workflow_live_steps.`predecessors`,workflow_live_steps.object_id,
	      workflow_live_steps.object_type,workflow_live_steps.id,workflow_live_steps.`actual_confirmation`,
	      workflow_live_steps.`step_completion`, workflow_live_steps.eta from workflow_live_steps, station_steps, workflow_stations 
	      where workflow_live_steps.station_step_id = station_steps.id 
	      and station_steps.workflow_station_id = workflow_stations.id 
	      and workflow_live_steps.id >= #{first_step.id} 
	      and workflow_live_steps.id <= #{last_step.id} 
	      order by workflow_stations.sequence, station_steps.sequence"
		  live_steps_qry_result = ActiveRecord::Base.connection.select_all live_steps_qry

	      #workflow_live_step_for_eta = workflow_live_step_for_eta.sort_by{|wls_sort| [wls_sort.station_step.workflow_station.sequence,wls_sort.station_step]}d
	      calculate_eta(live_steps_qry_result, hours_per_workday,workflow,current_user,workflow_live_step)

	      # workflow completion
	      set_workflow_completion_datetime(parent_l1, l1s_last_live_step, l2s_last_live_step, l3s_last_live_step)

		end

		def calculate_eta(live_steps_qry_result, hours_per_workday,workflow,current_user,currentWorkflowLiveStepConfirm)
	      live_steps_qry_result.each do |lsr|
	      	wls = WorkflowLiveStep.find_by_id(lsr["id"])
	      	if wls.object.present?
		      	if wls.object_type == 'L3'
		      		if wls.object.is_closed?
		      		else
		      			do_calculate_eta(wls, hours_per_workday,workflow,current_user,currentWorkflowLiveStepConfirm)
		      		end
		      	else
	      			do_calculate_eta(wls, hours_per_workday,workflow,current_user,currentWorkflowLiveStepConfirm)
		      	end	
		    end 	
	      end
    	end

		def do_calculate_eta(wls, hours_per_workday,workflow,current_user,currentWorkflowLiveStepConfirm)
	        pred_max_completion = ''
	        max_step_completion = ''
	        if wls.predecessors.present? && !wls.actual_confirmation.present? # && wls.is_active?
	          comp_attribute_value = wls.object
	          lang_attribute_value = wls.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
	                                            #check successor---------------------
	          predecessors_steps = wls.predecessors.split(",")
	          predecessors_step_ojbets = WorkflowLiveStep.where(id: predecessors_steps)
	          predecessors_step_ojbets.each_with_index do |pso, indx|
	            if indx == 0 and pso.step_completion.present?
	              pred_max_completion = pso.step_completion
	            elsif pso.step_completion.present?
	            	if DateTime.parse(pso.step_completion.to_s) > DateTime.parse(pred_max_completion.to_s)
	              		pred_max_completion = pso.step_completion
	          		end
	            end
	          end
	          
	          predecessors_step_ojbets.each_with_index do |pso, indx|
	            if indx == 0 and pso.step_completion.present?
	              station_step = wls.station_step
	              max_step_completion = station_step.calculate_step_completion(wls, pso.step_completion, comp_attribute_value, lang_attribute_value, hours_per_workday)
	            elsif pso.step_completion.present?
	              station_step = wls.station_step
	              step_completion_other = station_step.calculate_step_completion(wls, pso.step_completion, comp_attribute_value, lang_attribute_value, hours_per_workday)
	                if DateTime.parse(step_completion_other.to_s) > DateTime.parse(max_step_completion.to_s)
	                  max_step_completion = step_completion_other 
	                end
	            end
	          end
	          current_eta = wls.eta
	          wls.eta = pred_max_completion
	          wls.step_completion = max_step_completion
	          wls.save!

	          # save log start
	       #    no_of_comp = nil
      		#   no_of_lang = nil
      		#   if comp_attribute_value.present?
        # 	  	  no_of_comp = comp_attribute_value.num_component
      		#   end
		      # if lang_attribute_value.present?
		      #     no_of_lang = lang_attribute_value.value
		      # end
	       #    if current_eta != wls.eta
	       #    	TimestampLog.create(workflow_live_step_id: wls.id, 
					   #        		eta: wls.eta,
					   #        		user_id: current_user.id,
					   #        		work_flow_id: workflow.id,
					   #        		no_of_lang: no_of_lang,
					   #        		no_of_comp: no_of_comp)
	       #    end
	          # save log end
	        elsif wls.predecessors.present? && wls.actual_confirmation.present?
	          comp_attribute_value = wls.object
	          lang_attribute_value = wls.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
	          
			  station_step = wls.station_step
		      step_completion = station_step.calculate_step_completion(wls, wls.actual_confirmation, comp_attribute_value, lang_attribute_value, hours_per_workday)

		      wls.step_completion = step_completion
      		  wls.save!
	        end
	    end

	    def set_workflow_completion_datetime(parent_l1, l1s_last_live_step, l2s_last_live_step, l3s_last_live_step)

	    	# workflow complete block
	     	is_l1_completed = true
	      	is_l2_completed = true

  	        if l2s_last_live_step.present?
			    l2s_last_live_step.each do |l2_last_live_step|
			    	l2_eta_date = WorkflowLiveStep.find_by_id(l2_last_live_step.id).eta
			      	l2_object = l2_last_live_step.object
			      	l2_object.completed_estimate = l2_eta_date
			      	l2_object.save!

			        is_l3_completed = true	
		  	        if l3s_last_live_step[l2_last_live_step.object_id].present?
				      	l3s_last_live_step[l2_last_live_step.object_id].each do |l3_last_live_step|
				      		l3_eta_date = WorkflowLiveStep.find_by_id(l3_last_live_step.id).eta
					      	l3_object = l3_last_live_step.object
					      	l3_object.completed_estimate = l3_eta_date
					      	l3_object.save!

					      	# check any step, which are not confirmed
							is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l3_last_live_step.object_id} and workflow_live_steps.object_type = '#{l3_last_live_step.object_type}' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
					      	if is_any_step_without_actual.present?
					      		is_l3_completed = false
						      	l3_object = l3_last_live_step.object
						      	l3_object.completed_actual = nil
						      	l3_object.save!
					      	else
					      		l3_actual_date = WorkflowLiveStep.find_by_id(l3_last_live_step.id).actual_confirmation
						      	l3_object = l3_last_live_step.object
						      	l3_object.completed_actual = l3_actual_date
						      	l3_object.save!
					      	end
				      	end
			        end
				    if is_l3_completed
    					is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l2_last_live_step.object_id} and workflow_live_steps.object_type = '#{l2_last_live_step.object_type}' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
					    if is_any_step_without_actual.present?
					    	is_l2_completed = false
					      	l2_object = l2_last_live_step.object
					      	l2_object.completed_actual = nil
					      	l2_object.save!
					    else
					    	l2_actual_date = WorkflowLiveStep.find_by_id(l2_last_live_step.id).actual_confirmation
					      	l2_object = l2_last_live_step.object
					      	l2_object.completed_actual = l2_actual_date
      				    	maximum_l3_completed_actual_date = L3.where(l2_id: l2_object.id).maximum(:completed_actual)
				      		if DateTime.parse(maximum_l3_completed_actual_date.to_s) > DateTime.parse(l2_object.completed_actual.to_s)
				      			l2_object.completed_actual = maximum_l3_completed_actual_date
				      		end	
					      	l2_object.save!
				      	end
				    else
				      	is_l2_completed = false
  				    	l2_object = l2_last_live_step.object
				    	maximum_l3_completed_estimate_date = L3.where(l2_id: l2_object.id).maximum(:completed_estimate)
			      		if DateTime.parse(maximum_l3_completed_estimate_date.to_s) > DateTime.parse(l2_object.completed_estimate.to_s)
			      			l2_object.completed_estimate = maximum_l3_completed_estimate_date
			      		end
		      			l2_object.completed_actual = nil
		      			l2_object.save!
				    end

				end    
	  	    end

		    if l1s_last_live_step.present?
		    	l1_eta_date = WorkflowLiveStep.find_by_id(l1s_last_live_step.id).eta
		      	l1_object = l1s_last_live_step.object
      			maximum_l2_completed_estimate_date = L2.where(l1_id: l1_object.id).maximum(:completed_estimate)
		      	l1_object.completed_estimate = l1_eta_date
		    	if DateTime.parse(maximum_l2_completed_estimate_date.to_s) > DateTime.parse(l1_eta_date.to_s)
		      		l1_object.completed_estimate = maximum_l2_completed_estimate_date
		      	end	
		      	l1_object.save!

				if is_l2_completed
					is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l1s_last_live_step.object_id} and workflow_live_steps.object_type = '#{l1s_last_live_step.object_type}' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
				    if is_any_step_without_actual.present?
				      	l1_object = l1s_last_live_step.object
				      	l1_object.completed_actual = nil
				      	l1_object.save!
				    else
				    	l1_actual_date = WorkflowLiveStep.find_by_id(l1s_last_live_step.id).actual_confirmation
				      	l1_object = l1s_last_live_step.object
      					maximum_l2_completed_actual_date = L2.where(l1_id: l1_object.id).maximum(:completed_actual)
				      	l1_object.completed_actual = l1_actual_date
      			    	if DateTime.parse(maximum_l2_completed_actual_date.to_s) > DateTime.parse(l1_actual_date.to_s)
				      		l1_object.completed_actual = maximum_l2_completed_actual_date
				      	end	
				      	l1_object.save!
			      	end
		      	end
		    else

      			maximum_l2_completed_estimate_date = L2.where(l1_id: parent_l1.id).maximum(:completed_estimate)
		      	if is_l2_completed
		      		#abort('=======>parent_l1<===========')
      				maximum_l2_completed_actual_date = L2.where(l1_id: parent_l1.id).maximum(:completed_actual)
		      		parent_l1.completed_actual = maximum_l2_completed_actual_date
		      		parent_l1.completed_estimate = maximum_l2_completed_estimate_date
		      		parent_l1.save!
		      	else
		      		parent_l1.completed_actual = nil
		      		parent_l1.completed_estimate = maximum_l2_completed_estimate_date
		      		parent_l1.save!
		      	end
		    end
	    end
	end
end
