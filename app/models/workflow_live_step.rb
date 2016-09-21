class WorkflowLiveStep < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :station_step
	has_many :timestamp_logs

    def get_latest_timestamp_log
    	step_timestamp = ''
    	timestampLog = self.timestamp_logs.order(id: :desc).first
    	if timestampLog.present?
    		step_timestamp = timestampLog.actual_confirmation.strftime("%m/%d/%Y %I:%M %p")
    	else
    		if self.eta.present?
    			step_timestamp = self.eta.strftime("%m/%d/%Y %I:%M %p")
    			step_timestamp = 'ETA '+step_timestamp
    		end
    	end

    	return step_timestamp	
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

	      workflow_live_steps_l1 = WorkflowLiveStep.where(object_id: parent_l1.id, object_type: 'L1').order(:id)
	      workflow_live_steps_l1.each do |wls_l1|  
	        workflow_live_step_for_eta_ids << wls_l1
	      end
	      
	      parent_l1.l2s.each do |l2|
	        workflow_live_steps_l2 = WorkflowLiveStep.where(object_id: l2.id, object_type: 'L2').order(:id)
	        workflow_live_steps_l2.each do |wls_l2|  
	          workflow_live_step_for_eta_ids << wls_l2
	        end

	        l2.l3s.each do |l3|
	          workflow_live_steps_l3 = WorkflowLiveStep.where(object_id: l3.id, object_type: 'L3').order(:id)
	          workflow_live_steps_l3.each do |wls_l3|  
	            workflow_live_step_for_eta_ids << wls_l3
	          end
	        end
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
	          comp_attribute_value = wls.object #attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Comp'").first
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

	end
end
