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

	      l1_object = parent_l1
	      l2s_objects = []
	      l3s_objects = {}

	      workflow_live_steps_l1 = WorkflowLiveStep.where(object_id: parent_l1.id, object_type: 'L1').order(:id)
	      workflow_live_steps_l1.each do |wls_l1|  
	        workflow_live_step_for_eta_ids << wls_l1
	      end
	      
	      parent_l1.l2s.each do |l2|
	        workflow_live_steps_l2 = WorkflowLiveStep.where(object_id: l2.id, object_type: 'L2').order(:id)
	        l2s_objects << l2
	        workflow_live_steps_l2.each do |wls_l2|  
	          workflow_live_step_for_eta_ids << wls_l2
	        end

	        l3sObjects = []
	        l2.l3s.each do |l3|
	          workflow_live_steps_l3 = WorkflowLiveStep.where(object_id: l3.id, object_type: 'L3').order(:id)
	          if !l3.is_closed
	          	l3sObjects << l3
	      	  end
	          workflow_live_steps_l3.each do |wls_l3|  
	            workflow_live_step_for_eta_ids << wls_l3
	          end
	        end
	        l3s_objects[l2.id] = l3sObjects
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
	      if l1_object.status.downcase! != 'cancel'
	     	 set_workflow_completion_datetime(l1_object, l2s_objects, l3s_objects)
	  	  end

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
	            	if pred_max_completion.present?
		            	if DateTime.parse(pso.step_completion.to_s) > DateTime.parse(pred_max_completion.to_s)
		              		pred_max_completion = pso.step_completion
		          		end
		          	else
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
	                if step_completion_other.present? and max_step_completion.present?
		                if DateTime.parse(step_completion_other.to_s) > DateTime.parse(max_step_completion.to_s)
		                  max_step_completion = step_completion_other 
		                end
	            	else
	            		max_step_completion = step_completion_other 
	            	end
	            end
	          end

	          current_eta = wls.eta
	          wls.eta = pred_max_completion
	          wls.step_completion = max_step_completion
	          wls.save!
	        elsif wls.predecessors.present? && wls.actual_confirmation.present?
	          comp_attribute_value = wls.object
	          lang_attribute_value = wls.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
	          
			  station_step = wls.station_step
		      step_completion = station_step.calculate_step_completion(wls, wls.actual_confirmation, comp_attribute_value, lang_attribute_value, hours_per_workday)

		      wls.step_completion = step_completion
      		  wls.save!
	        end
	    end

	    def set_workflow_completion_datetime(l1_object, l2s_objects, l3s_objects)

	    	# workflow complete block
	     	is_l1_completed = true
	      	is_l2_completed = true

	      	if l2s_objects.present?
	      		l2s_objects.each do |l2_object|
	      			if l2_object.status.downcase! != 'cancel'
		      			max_l2_eta = WorkflowLiveStep.where(object_id: l2_object.id, object_type: 'L2').maximum(:eta)	 
		      			l2_object.completed_estimate = max_l2_eta

		      			is_l3_completed = true
		      			if l3s_objects[l2_object.id].present?
		      				l3s_objects[l2_object.id].each do |l3_object|
		      					if !l3_object.is_closed and l3_object.status.downcase! != 'cancel'
					      			max_l3_eta = WorkflowLiveStep.where(object_id: l3_object.id, object_type: 'L3').maximum(:eta)
					      			l3_object.completed_estimate = max_l3_eta

									is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l3_object.id} and workflow_live_steps.object_type = 'L3' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
									if is_any_step_without_actual.present?
							      		is_l3_completed = false
								      	l3_object.completed_actual = nil
							      	else
							      		l3_max_actual_date = WorkflowLiveStep.where(object_id: l3_object.id, object_type: 'L3').maximum(:actual_confirmation)
								      	l3_object.completed_actual = l3_max_actual_date
							      	end
							      	l3_object.save!
						      	end
		      				end
		      			end

		      			# set actual complete date of L2 and update estimate complete if needed
		      			if is_l3_completed
		      				is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l2_object.id} and workflow_live_steps.object_type = 'L2' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
						    if is_any_step_without_actual.present?
						    	is_l2_completed = false
						      	l2_object.completed_actual = nil
						    else
					      		l2_max_actual_date = WorkflowLiveStep.where(object_id: l2_object.id, object_type: 'L2').maximum(:actual_confirmation)
						      	l2_object.completed_actual = l2_max_actual_date
	      				    	maximum_l3s_completed_actual_date = L3.where(l2_id: l2_object.id).maximum(:completed_actual)
	      				    	if maximum_l3s_completed_actual_date.presence and l2_max_actual_date.presence
						      		if DateTime.parse(maximum_l3s_completed_actual_date.to_s) > DateTime.parse(l2_max_actual_date.to_s)
						      			l2_object.completed_actual = maximum_l3s_completed_actual_date
						      		end	
					      		end
					      	end
		      			else
					      	is_l2_completed = false
					    	maximum_l3s_completed_estimate_date = L3.where(l2_id: l2_object.id).maximum(:completed_estimate)
					    	if maximum_l3s_completed_estimate_date.presence and max_l2_eta.presence
					      		if DateTime.parse(maximum_l3s_completed_estimate_date.to_s) > DateTime.parse(max_l2_eta.to_s)
					      			l2_object.completed_estimate = maximum_l3s_completed_estimate_date
					      		end
				      		end
			      			l2_object.completed_actual = nil
		      			end
				      	l2_object.save!
				    end  	
	      		end
	      	end

	      	if l1_object.present?
	      		max_l1_eta = WorkflowLiveStep.where(object_id: l1_object.id, object_type: 'L1').maximum(:eta)
      			l1_object.completed_estimate = max_l1_eta

      			maximum_l2_completed_estimate_date = L2.where(l1_id: l1_object.id).maximum(:completed_estimate)
				if maximum_l2_completed_estimate_date.presence and max_l1_eta.presence
			    	if DateTime.parse(maximum_l2_completed_estimate_date.to_s) > DateTime.parse(l1_eta_date.to_s)
			      		l1_object.completed_estimate = maximum_l2_completed_estimate_date
			      	end	
		      	else
				    l1_object.completed_estimate = maximum_l2_completed_estimate_date	
				end

		      	if is_l2_completed
					is_any_step_without_actual = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.is_active= #{true} and workflow_live_steps.object_id= #{l1_object.id} and workflow_live_steps.object_type = 'L1' and workflow_live_steps.actual_confirmation IS NULL and station_steps.is_visible = #{true}")
				    if is_any_step_without_actual.present?
				      	l1_object.completed_actual = nil
				    else
				    	l1_max_actual_date = WorkflowLiveStep.where(object_id: l1_object.id, object_type: 'L1').maximum(:actual_confirmation)
				      	l1_object.completed_actual = l1_max_actual_date
      					
      					maximum_l2_completed_actual_date = L2.where(l1_id: l1_object.id).maximum(:completed_actual)
				      	if maximum_l2_completed_actual_date.presence and l1_max_actual_date.presence
	      			    	if DateTime.parse(maximum_l2_completed_actual_date.to_s) > DateTime.parse(l1_max_actual_date.to_s)
					      		l1_object.completed_actual = maximum_l2_completed_actual_date
					      	end
					    else
					      l1_object.completed_actual = maximum_l2_completed_actual_date	
				      	end
			      	end
		      	end
		    	l1_object.save!  	
	      	end
	    end
	end
end
