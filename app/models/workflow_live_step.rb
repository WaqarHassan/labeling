class WorkflowLiveStep < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :station_step

	class << self

		def get_steps_calculate_eta(workflow_live_step,workflow)

	  	  BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
	      BusinessTime::Config.end_of_workday = workflow.end_of_workday

	      workflow.holidays.each do |holiday|
	        BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
	      end

	      hours_per_workday = workflow.hours_per_workday.present? ? workflow.hours_per_workday : 1

		  workflow_live_step_for_eta = []                     
	      if workflow_live_step.object_type == "L3"
	        parent_l1 = workflow_live_step.object.l2.l1
	      elsif workflow_live_step.object_type == "L2"
	        parent_l1 = workflow_live_step.object.l1
	      elsif workflow_live_step.object_type == "L1"
	        parent_l1 = workflow_live_step.object
	      end

	      workflow_live_steps_l1 = WorkflowLiveStep.where(object_id: parent_l1.id, object_type: 'L1')
	      workflow_live_steps_l1.each do |wls_l1|  
	        workflow_live_step_for_eta << wls_l1
	      end
	      
	      parent_l1.l2s.each do |l2|
	        workflow_live_steps_l2 = WorkflowLiveStep.where(object_id: l2.id, object_type: 'L2')
	        workflow_live_steps_l2.each do |wls_l2|  
	          workflow_live_step_for_eta << wls_l2
	        end

	        l2.l3s.each do |l3|
	          workflow_live_steps_l3 = WorkflowLiveStep.where(object_id: l3.id, object_type: 'L3')
	          workflow_live_steps_l3.each do |wls_l3|  
	            workflow_live_step_for_eta << wls_l3
	          end
	        end
	      end
	     
	      workflow_live_step_for_eta = workflow_live_step_for_eta.sort_by{|wls_sort| wls_sort.station_step.sequence} 
	      calculate_eta(workflow_live_step_for_eta, hours_per_workday)
		end

		def calculate_eta(workflow_live_step_for_eta, hours_per_workday)

	      workflow_live_step_for_eta.each do |wls|
	        pred_max_completion = ''
	        max_step_completion = ''
	        if wls.predecessors.present? && !wls.actual_confirmation.present?
	          comp_attribute_value = wls.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Comp'").first
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
	              max_step_completion = station_step.calculate_step_completion(pso.step_completion, comp_attribute_value, lang_attribute_value, hours_per_workday)
	            elsif pso.step_completion.present?
	              station_step = wls.station_step
	              step_completion_other = station_step.calculate_step_completion(pso.step_completion, comp_attribute_value, lang_attribute_value, hours_per_workday)
	                if DateTime.parse(step_completion_other.to_s) > DateTime.parse(max_step_completion.to_s)
	                  max_step_completion = step_completion_other 
	                end
	            end
	          end
	          wls.eta = pred_max_completion
	          wls.step_completion = max_step_completion
	          wls.save!
	        end
	      end
    	end

	end
end
