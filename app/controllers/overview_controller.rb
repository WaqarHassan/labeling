class OverviewController < ApplicationController
	skip_authorization_check
  
	def index
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)

    if session[:filter_object_type] == 'L1' 
      @l1s = @workflow.l1s.where(id: [session[:filter_object_id]])
  
    elsif session[:filter_object_type] == 'L2'
      @show_search_result_l2 = 'filter_type_l2'
      @l2_records = L2.where(id: session[:filter_object_id])
      @l1s = @workflow.l1s.where(id: @l2_records.first.l1_id)
   
    elsif session[:filter_object_type] == 'L3'
      @show_search_result_l2 = 'filter_type_l2'
      if !session[:new_object_added].present? 
        @show_search_result_l3 = 'filter_type_l3'
      end
      l3 = L3.find(session[:filter_object_id])
      ll2 = l3.l2
      @l3_records = L3.where(id: l3.id)
      @l2_records = L2.where(id: @l3_records.first.l2_id)
      @l1s = @workflow.l1s.where(id: @l2_records.first.l1_id)

    else
      @l1s = @workflow.l1s.where(status: 'Active').order(:id)       
    end
     

    if session[:wildcard].present?
      @wildcard = session[:wildcard]
    end
    if session[:exact].present?
      @exact = session[:exact]
    end
    if session[:q_string].present?
      q_string = session[:q_string]
      @serach_result = WorkFlow.search(q_string)
    end
	end

  def open_info_modal_l1
    @type = 'L1' 
    @l1 = L1.find(params[:l1_id])
    @status_ = @l1.status

    @reasons = ReasonCode.where(status: @status_,
     recording_level: @type )


    @additional_info = AdditionalInfo.new
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @info_status = @workflow.statuses.where(recording_level: 'L1')
    @additional_info_data = @workflow.additional_infos.where(object_id: @l1.id, object_type: 'L1').order(id: :desc)
    respond_to do |format|
      format.html
      format.js
    end
   end

   def open_info_modal_l2
    @type = 'L2'
    @l2 = L2.find(params[:l2_id])
    @status_ = @l2.status

    @reasons = ReasonCode.where(status: @status_,
     recording_level: @type )

    @additional_info = AdditionalInfo.new
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @info_status = @workflow.statuses.where(recording_level: 'L2')
    @additional_info_data = @workflow.additional_infos.where(object_id: @l2.id, object_type: 'L2').order(id: :desc)
    respond_to do |format|
      format.html
      format.js
    end
   end

   def open_info_modal_l3
    @type = 'L3'
    @l3 = L3.find(params[:l3_id])
    @status_ = @l3.status

    @reasons = ReasonCode.where(status: @status_,
     recording_level: @type )

    @additional_info = AdditionalInfo.new
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @info_status = @workflow.statuses.where(recording_level: 'L3')
    @additional_info_data = @workflow.additional_infos.where(object_id: @l3.id, object_type: 'L3').order(id: :desc)
    respond_to do |format|
      format.html
      format.js
    end
   end

  def update_workflow
    @object_type = params[:object_type]
    @object_id = params[:object_id]
    if @object_type == 'L1'
      @object = L1.find(@object_id)
    elsif @object_type == 'L2' 
      @object = L2.find(@object_id)
    elsif @object_type == 'L3' 
      @object = L3.find(@object_id)
    end
    
    @live_station_steps = WorkflowLiveStep.where(object_type: @object_type, object_id: @object_id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def workflow_update
    live_steps = params[:live_steps]
    object_type = params[:object_type]
    object_id = params[:object_id]

    WorkflowLiveStep.where(object_type: object_type, object_id: object_id).update_all(is_active: false)
    if live_steps.present?
      live_steps = live_steps.flatten
      WorkflowLiveStep.where(id: live_steps).update_all(is_active: true)
      WorkflowLiveStep.where(object_type: object_type, object_id: object_id, is_active: false).update_all(actual_confirmation: nil)
    end  
    workflowLiveStep = WorkflowLiveStep.find_by_object_type_and_object_id(object_type, object_id)
    if workflowLiveStep.present?
      WorkflowLiveStep.get_steps_calculate_eta(workflowLiveStep, @workflow,current_user)
    end
    redirect_to root_path, notice: 'Workflow Updated'
  end

   def add_additional_info
      params[:additional_info][:info_timestamp] = L1.set_db_datetime_format(params[:additional_info][:info_timestamp])
      
      if params[:additional_info][:info_timestamp] == ""
        params[:additional_info][:info_timestamp] = Time.now.strftime("%d/%m/%Y %H:%M")
      end

      if params[:save_note_only] == 'savenoteonly'
        AdditionalInfo.create(additional_info_params_note_only)
      
      else
         AdditionalInfo.create(additional_info_params)
        if params[:additional_info][:object_type] == 'L1'
          l1 = L1.find(params[:additional_info][:object_id])
          l1.update(status: params[:additional_info][:status])
        elsif params[:additional_info][:object_type] == 'L2'
           l2 = L2.find(params[:additional_info][:object_id])
           l2.update(status: params[:additional_info][:status])
        elsif params[:additional_info][:object_type] == 'L3'
           l3 = L3.find(params[:additional_info][:object_id])
          l3.update(status: params[:additional_info][:status])
        end
      end
     
      #abort()
      redirect_to root_path, notice: 'Additional Info was successfully created.'
   end
  def get_reasons
    @reasons = ReasonCode.where(status: params[:additional_info][:status],
     recording_level: params[:l_type] )

      respond_to do |format|
        format.html
        format.js
      end
  end
 

  def get_steps
    @steps = StationStep.where(workflow_station_id: params[:rework_info][:station_id] )
    respond_to do |format|
      format.html
      format.js
    end
  end

  #GET rework Modal
  def open_rework_modal
    @wf_step_id = params[:wf_step_id]
    workflow_live_step = WorkflowLiveStep.find(@wf_step_id)
    @rework = ReworkInfo.new
    @object = workflow_live_step.object

    rework_components = 0
      if @object.class.name == 'L3'
        reworks = L3.where(rework_parent_id: @object.id, is_closed: false)
        reworks.each do |rework|
          rework_components += rework.num_component
        end
        closed_reworks = L3.where(rework_parent_id: @object.id, is_closed: true)
        closed_reworks.each do |clos_rework|
          closed_reworks_partial = L3.where(rework_parent_id: clos_rework.id, is_closed: false)
          closed_reworks_partial.each do |closedreworkspartial|
            rework_components += closedreworkspartial.num_component
          end
        end
    end
    @rework_components = rework_components
    @object_num_component = @object.num_component.present? ? @object.num_component : 1
    @object_num_component = @object_num_component.to_i - rework_components.to_i

    @object_live_steps = @object.workflow_live_steps
    @object_type = workflow_live_step.object_type
    @user_id = current_user.id
    @current_step = workflow_live_step.station_step
    @current_station = workflow_live_step.station_step.workflow_station
    @reason_codes = @workflow.reason_codes.where(status: 'Rework', recording_level: workflow_live_step.object_type)
    @level_workflow_stations = @workflow.workflow_stations.joins(:station_steps).where("station_steps.recording_level='#{workflow_live_step.object_type}' and workflow_stations.sequence <= #{@current_station.sequence} and workflow_stations.is_visible=true").order(:sequence).uniq

    @level_steps = []
    @level_workflow_stations.each do |level_station|
      if level_station.id == @current_station.id
        level_station.station_steps.where("is_visible=#{true} and recording_level='#{workflow_live_step.object_type}' and sequence <= #{@current_step.sequence}").order(:sequence).each do |stp|
         liveStepObject = @object_live_steps.find{|live_step| live_step.station_step_id == stp.id }
          if liveStepObject.is_active?
            @level_steps << stp
          end
        end
      else
        level_station.station_steps.where("is_visible=#{true} and recording_level='#{workflow_live_step.object_type}'").order(:sequence).each do |stp|
          liveStepObject = @object_live_steps.find{|live_step| live_step.station_step_id == stp.id }
          if liveStepObject.is_active?
            @level_steps << stp
          end
        end
      end  
    end

    if workflow_live_step.object_type == 'L1'
      @l1 = L1.find(workflow_live_step.object_id)
    elsif workflow_live_step.object_type == 'L2'
      @l2 = L2.find(workflow_live_step.object_id)
    elsif workflow_live_step.object_type == 'L3'
      @l3 = L3.find(workflow_live_step.object_id)
    end  
    respond_to do |format|
      format.html
      format.js
    end
  end

   #POST rework Modal
  def create_rework_info
     mew_rework_info_object = ReworkInfo.create(rework_info_params)
     
     reset_type = params[:reset_type]
     move_original_record_back_to_step = params[:move_original_record_back_to_step]
     rework_date_time = params[:rework_date_time]
     rework_parent_id = params[:rework_parent_id]
     rework_object_type = params[:rework_info][:object_type]
     parent_total_num_component = params[:num_component]
     num_component_rework = params[:num_component_rework]
     component_already_in_rework = params[:component_already_in_rework]
     rework_start_step = params[:rework_start_step]
     component_already_in_rework = component_already_in_rework.present? ? component_already_in_rework : 0
     remaining_parent_component = parent_total_num_component.to_i - num_component_rework.to_i

     # find parent of rework
     l3_object = L3.find(rework_parent_id)
     l3_rework_name = get_rework_name(l3_object.name)
     l3_object.num_component_rework = num_component_rework.to_i + component_already_in_rework.to_i

     # create new rework
     l3_rework = L3.new
     l3_rework.user_id = current_user.id
     l3_rework.name = l3_rework_name
     l3_rework.status = 'Active'
     l3_rework.business_unit = l3_object.business_unit
     l3_rework.l2_id = l3_object.l2_id
     l3_rework.rework_parent_id = rework_parent_id
     l3_rework.num_component = num_component_rework
     reason = ReasonCode.find_by_recording_level('ReworkParent')

     # -----------------if fulllllllllllllll Rework
     if parent_total_num_component.to_i == num_component_rework.to_i
      l3_object.is_full_rework = true
      l3_object.is_closed = true
      l3_object.status = 'Closed'
      l3_object.is_main_record = false
      l3_rework.is_main_record = true

      if l3_object.merge_back_with_id.present?
        l3_rework.merge_back_with_id = l3_object.merge_back_with_id
      end
        
      AdditionalInfo.create(info_timestamp: Time.now ,object_id: l3_object.id, object_type: rework_object_type, 
        status: 'Closed', reason_code_id: reason.id, work_flow_id: @workflow.id, user_id: current_user.id)
    
      WorkflowLiveStep.where(object_type: rework_object_type, object_id: rework_parent_id, actual_confirmation: nil).update_all(is_active: false)
     
      # -----------------else Partial Rework-------------------
     elsif num_component_rework.to_i < parent_total_num_component.to_i
      rework_type = 'partial_rework' 


      l3_rework.merge_back_with_id = rework_parent_id  

     end

     l3_object.save!
     if l3_rework.save!
         # create archive info of new rework
        AdditionalInfo.create(info_timestamp: Time.now ,object_id: l3_rework.id, object_type: rework_object_type, 
        status: 'Active', work_flow_id: @workflow.id, user_id: current_user.id)

        start_workflow_live_step = WorkflowLiveStep.find_by_station_step_id_and_object_id_and_object_type(rework_start_step,rework_parent_id, rework_object_type)
        mew_rework_info_object.new_rework_id = l3_rework.id
        mew_rework_info_object.new_rework_type = rework_object_type

        # save reset type and back record if partial rework and move original record back to selected
        if move_original_record_back_to_step.present? and parent_total_num_component.to_i != num_component_rework.to_i
          mew_rework_info_object.move_original_record_back_to_step = move_original_record_back_to_step
          mew_rework_info_object.reset_type = reset_type
        end
        mew_rework_info_object.rework_start_step = start_workflow_live_step.id
        mew_rework_info_object.save!

        # copy all parent attributes to new rewwork 
        parent_lang_attribute_values = l3_object.attribute_values
        parent_lang_attribute_values.each do |lang_attributeValue|
          AttributeValue.create(label_attribute_id: lang_attributeValue.label_attribute_id,value: lang_attributeValue.value,
            object_type: lang_attributeValue.object_type, object_id: l3_rework.id)
        end

        # change Actual confirmation and log timestap if partial rework and move original record back to selected
        if move_original_record_back_to_step.present? and parent_total_num_component.to_i != num_component_rework.to_i
          noOf_comp = l3_object.num_component.to_i - l3_object.num_component_rework.to_i
          no_of_lang_comp = l3_object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
          
          # change actual confirmation
          actual_confirmation = L1.set_db_datetime_format(rework_date_time)
          original_record_backTO_live_step = WorkflowLiveStep.find_by_station_step_id_and_object_id_and_object_type(move_original_record_back_to_step.to_i,rework_parent_id, rework_object_type)
          original_record_backTO_live_step.actual_confirmation = actual_confirmation
          original_record_backTO_live_step.save!
          
          # save timestamp log
           TimestampLog.create(workflow_live_step_id: original_record_backTO_live_step.id,
                            actual_confirmation: actual_confirmation,
                            user_id: current_user.id,
                            work_flow_id: @workflow.id,
                            no_of_comp: noOf_comp,
                            no_of_lang: no_of_lang_comp)

        else
           original_record_backTO_live_step = nil
        end

        # copy parent live steps for new rework
        live_steps_new_rework_object = nil
        rework_live_steps = WorkflowLiveStep.where(object_type: rework_object_type, object_id: rework_parent_id)
        rework_live_steps.each do |original_rework|
          live_steps_new_rework = WorkflowLiveStep.new
          live_steps_new_rework.station_step_id = original_rework.station_step_id
          live_steps_new_rework.object_id = l3_rework.id
          live_steps_new_rework.object_type = original_rework.object_type
          live_steps_new_rework.predecessors = original_rework.predecessors
          live_steps_new_rework.step_completion = original_rework.step_completion
          live_steps_new_rework.eta = original_rework.eta
          if original_rework.id >= start_workflow_live_step.id
            live_steps_new_rework.is_active = true
          else
            live_steps_new_rework.is_active = false
          end

          # reset the confirmation of parent record on the basis of RESET FILTER 
          if parent_total_num_component.to_i != num_component_rework.to_i and original_record_backTO_live_step.present?
            if reset_type == 'keep_all' and original_rework.id > original_record_backTO_live_step.id
              original_rework.actual_confirmation = original_rework.actual_confirmation
            elsif reset_type == 'reset_all' and original_rework.id > original_record_backTO_live_step.id
              original_rework.actual_confirmation = nil
            end
            original_rework.save!
          end

          if live_steps_new_rework.save!
            # save timestamp log
            numberOfLangComp = 0
            noOfLangComp = l3_rework.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
            if noOfLangComp.present?
              numberOfLangComp = noOfLangComp.value
            end
            TimestampLog.create(workflow_live_step_id: live_steps_new_rework.id,
                            actual_confirmation: live_steps_new_rework.actual_confirmation,
                            user_id: current_user.id,
                            work_flow_id: @workflow.id,
                            no_of_comp: l3_rework.num_component,
                            no_of_lang: numberOfLangComp)

            predecessor = live_steps_new_rework.predecessors
            step_predecessor = WorkflowLiveStep.where("id in (#{predecessor})")
            predecessor_list = ''
            step_predecessor.each do |st_pred|
              station_stepID = st_pred.station_step_id
              start_workflow_liveStep = WorkflowLiveStep.find_by_station_step_id_and_object_id_and_object_type(station_stepID,l3_rework.id, rework_object_type)
              if start_workflow_liveStep.present?
                predecessor_list = predecessor_list+','+start_workflow_liveStep.id.to_s
              end
            end
            if predecessor_list != ''
              predecessor_list.slice!(0)
              live_steps_new_rework.predecessors = predecessor_list
              live_steps_new_rework.save!
            end

            live_steps_new_rework_object = live_steps_new_rework
          end
        end

        #-----------------------start mising predecessors L2
        @l3 = l3_object 
        workflow_live_steps_empty_pred = WorkflowLiveStep.where(object_id: @l3.l2.id, object_type: 'L2')
        workflow_live_steps_empty_pred.each do |pred_stp|
          predecessors = Transition.where(station_step_id: pred_stp.station_step_id)
          predecessors_step_empty = ''
          workflow_live_steps_pred = []
          predecessors.each do |pred|
            workflow_live_steps_pred_l1 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l3.l2.l1.id, object_type: 'L1')
            workflow_live_steps_pred_l1.each do |wlsp_l1|
              workflow_live_steps_pred << wlsp_l1
            end

            #@l3.l2.l1.l2s.each do |l1_l2|
              workflow_live_steps_pred_l2 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l3.l2.id, object_type: 'L2')
              workflow_live_steps_pred_l2.each do |wlsp_l2|
                workflow_live_steps_pred << wlsp_l2
              end

              @l3.l2.l3s.each do |l2_l3|
                workflow_live_steps_pred_l3 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: l2_l3.id, object_type: 'L3')
                workflow_live_steps_pred_l3.each do |wlsp_l3|
                  workflow_live_steps_pred << wlsp_l3
                end

              end
            #end

          end
          workflow_live_steps_pred.each do |wls|
            predecessors_step_empty = predecessors_step_empty+','+wls.id.to_s
          end

          if predecessors_step_empty != ''
            predecessors_step_empty.slice!(0)
          end
          pred_stp.update(predecessors: predecessors_step_empty)
        end

        #-----------------------start mising predecessors for L1
        workflow_live_steps_empty_pred = WorkflowLiveStep.where(object_id: @l3.l2.l1.id, object_type: 'L1')
        workflow_live_steps_empty_pred.each do |pred_stp|
          predecessors = Transition.where(station_step_id: pred_stp.station_step_id)
          predecessors_step_empty = ''
          workflow_live_steps_pred = []
          predecessors.each do |pred|
            workflow_live_steps_pred_l1 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l3.l2.l1.id, object_type: 'L1')
            workflow_live_steps_pred_l1.each do |wlsp_l1|
              workflow_live_steps_pred << wlsp_l1
            end
            
            @l3.l2.l1.l2s.each do |l1_l2|
              workflow_live_steps_pred_l2 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: l1_l2.id, object_type: 'L2')
              workflow_live_steps_pred_l2.each do |wlsp_l2|
                workflow_live_steps_pred << wlsp_l2
              end

              l1_l2.l3s.each do |l2_l3|
                workflow_live_steps_pred_l3 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: l2_l3.id, object_type: 'L3')
                workflow_live_steps_pred_l3.each do |wlsp_l3|
                  workflow_live_steps_pred << wlsp_l3
                end

              end
            end

          end
          workflow_live_steps_pred.each do |wls|
            predecessors_step_empty = predecessors_step_empty+','+wls.id.to_s
          end

          if predecessors_step_empty != ''
            predecessors_step_empty.slice!(0)
          end
          pred_stp.update(predecessors: predecessors_step_empty)
        end

        if l3_rework.workflow_live_steps.present?
         new_rework_first_object = l3_rework.workflow_live_steps.where(is_active: true).first
         actual_confirmation = L1.set_db_datetime_format(rework_date_time)
         calculate_eta_completion(actual_confirmation, new_rework_first_object)
        end

     end

     redirect_to root_path, notice: 'Rework Info was successfully created.'
  end

    #GET task Confirmation
  def open_confirm_modal
    session.delete(:open_confirm_modal)
    @wf_step_id = params[:wf_step_id]
    workflow_live_tep = WorkflowLiveStep.find(@wf_step_id)
   
    @st_step = workflow_live_tep.station_step.step_name
    @st_name = workflow_live_tep.station_step.workflow_station.station_name


    if workflow_live_tep.object_type == 'L1'
      @l1 = L1.find(workflow_live_tep.object_id)
    elsif workflow_live_tep.object_type == 'L2'
      @l2 = L2.find(workflow_live_tep.object_id)
    elsif workflow_live_tep.object_type == 'L3'
      @l3 = L3.find(workflow_live_tep.object_id)
    end  
    respond_to do |format|
      format.html { render :partial => "confirm_modal" }
      format.js
    end
  end

  def update_workflow_status
    workflow_id = params[:workflow_id]
    WorkFlow.update_all(is_in_use: false)
    WorkFlow.update(workflow_id, is_in_use: true)
    session.delete(:q_string)
    session.delete(:wildcard)
    session.delete(:exact)
    session.delete(:filter_object_id)
    session.delete(:filter_object_type)
    session.delete(:new_object_added)

    redirect_to root_path, notice: 'WorkFlow was successfully changed.'
  end

  def search
    q_string = '';
    session[:wildcard] = params[:wildcard]
    session[:exact] = params[:exact]
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
    session[:q_string] = q_string
    if q_string != ''
      @serach_result = WorkFlow.search(q_string)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def reject_reason_modal
    session.delete(:open_reason_modal)
    l2_id = params[:id]
    @l2 = L2.find(l2_id)

    @reason_codes = @workflow.reason_codes.where(status: 'Rejected', recording_level: 'L2')
    respond_to do |format|
      format.html { render :partial => "reject_reason_modal" }
      format.js
    end
  end

  def save_reject_reason
    additional_info_id = session[:additional_info_id]
    AdditionalInfo.update(additional_info_id, reason_code_id: params[:additional_info][:reason_code_id], note: params[:additional_info][:note])
    session.delete(:additional_info_id)
    redirect_to root_path, notice: 'Reject reason saved'
  end

  def project_deatils_l1
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    l1_list = params[:l1_id].split('_')
    session[:filter_object_id] = l1_list
    session[:filter_object_type] = 'L1'
    session.delete(:new_object_added)
    @l1s = L1.where(id: [l1_list])

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def project_deatils_l2
    @show_search_result_l2 = 'filter_type_l2' 
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    l2_id = params[:l2_id]
    session[:filter_object_id] = l2_id
    session[:filter_object_type] = 'L2'
    session.delete(:new_object_added)

    @l2_records = L2.where(id: l2_id)
    @l1s = L1.where(id: @l2_records.first.l1_id)

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def project_deatils_l3
    @show_search_result_l2 = 'filter_type_l2' 
    @show_search_result_l3 = 'filter_type_l3' 
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    l3_id = params[:l3_id]
    session[:filter_object_id] = l3_id
    session[:filter_object_type] = 'L3'
    session.delete(:new_object_added)

    l3 = L3.find(l3_id)
    ll2 = l3.l2

    @l3_records = L3.where(id: l3_id)
    @l2_records = L2.where(id: @l3_records.first.l2_id)
    @l1s = L1.where(id: @l2_records.first.l1_id)

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def show_all_db
    session.delete(:filter_object_id)
    session.delete(:filter_object_type)
    session.delete(:new_object_added)
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @l1s = @workflow.l1s.where(status: 'Active').order(:id)
    respond_to do |format|
      format.html
      format.js
    end 
    
  end

  def clear_search
    session.delete(:q_string)
    session.delete(:wildcard)
    session.delete(:exact)
    session.delete(:filter_object_id)
    session.delete(:filter_object_type)
    @label_attributes = @workflow.label_attributes.order(:sequence) #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @l1s = @workflow.l1s.where(status: 'Active').order(:id)
    respond_to do |format|
      format.html
      format.js
    end 

  end


   #POST Task Confirmation

  def update_task_confirmation
    session.delete(:open_confirm_modal)
    actualConfirmation = params[:workflow_live_step][:actual_confirmation]
    actual_confirmation = L1.set_db_datetime_format(actualConfirmation)
    workflow_live_step = WorkflowLiveStep.find(params[:id])
    calculate_eta_completion(actual_confirmation, workflow_live_step)
    if workflow_live_step.object.status != 'Active'
      workflow_live_step.object.update(:status => 'Active')
      AdditionalInfo.create(object_id: workflow_live_step.object_id, object_type: workflow_live_step.object_type, status: 'Active', work_flow_id: @workflow.id, user_id: current_user.id)
    end
    
    redirect_to root_path, notice: 'Step confirmation done'
  end

  private

    def get_rework_name(object_name, indx = 1)
      parent_object_name = object_name.split('-R')[0]
      object_name_new = parent_object_name+'-R'+indx.to_s
      is_name_exist = L3.find_by_name(object_name_new)
      if is_name_exist.present?
        indx +=1
        get_rework_name(object_name, indx)
      else
       return object_name_new
      end
    end

    def calculate_eta_completion(actual_confirmation, workflow_live_step)
      BusinessTime::Config.beginning_of_workday = @workflow.beginning_of_workday
      BusinessTime::Config.end_of_workday = @workflow.end_of_workday

      @workflow.holidays.each do |holiday|
        BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
      end

      comp_attribute_value = workflow_live_step.object #attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Comp'").first
      lang_attribute_value = workflow_live_step.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
      hours_per_workday = @workflow.hours_per_workday.present? ? @workflow.hours_per_workday : 1

                          # calculate step completion for step which id confirmed
      station_step = workflow_live_step.station_step
      step_completion = station_step.calculate_step_completion(workflow_live_step, actual_confirmation, comp_attribute_value, lang_attribute_value, hours_per_workday)

      workflow_live_step.actual_confirmation = actual_confirmation
      workflow_live_step.step_completion = step_completion
      workflow_live_step.save!

      # save log start
      no_of_comp = nil
      no_of_lang = nil
      if comp_attribute_value.present?
        no_of_comp = comp_attribute_value.num_component
      end
      if lang_attribute_value.present?
          no_of_lang = lang_attribute_value.value
      end
       TimestampLog.create(workflow_live_step_id: workflow_live_step.id,
                        actual_confirmation: actual_confirmation,
                        user_id: current_user.id,
                        work_flow_id: @workflow.id,
                        no_of_comp: no_of_comp,
                        no_of_lang: no_of_lang)
      # save log end
       
      WorkflowLiveStep.get_steps_calculate_eta(workflow_live_step, @workflow,current_user)
      
    end



    def calculate_eta_completion_backup(actual_confirmation, workflow_live_step)
      comp_attribute_value = workflow_live_step.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Comp'").first
      lang_attribute_value = workflow_live_step.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first

      station_step = workflow_live_step.station_step
      step_completion = station_step.calculate_step_completion(workflow_live_step, actual_confirmation, comp_attribute_value, lang_attribute_value)

      workflow_live_step.actual_confirmation = actual_confirmation
      workflow_live_step.step_completion = step_completion
      workflow_live_step.save!

      workflow_live_steps = WorkflowLiveStep.where(object_id: workflow_live_step.object_id, object_type: workflow_live_step.object_type).where("id > #{workflow_live_step.id}").order(:id)
       
      workflow_live_steps.each do |wls|
                                            #check successor---------------------
        transitions = Transition.where(station_step_id: wls.station_step_id)
                                            #successor calculation
        transitions.each_with_index do |transition, indx|
          pre_workflow_live_step = WorkflowLiveStep.find_by_station_step_id_and_object_id_and_object_type(transition.previous_station_step_id, wls.object_id, wls.object_type)
          if indx == 0
            if pre_workflow_live_step.present? and pre_workflow_live_step.step_completion.present?
                station_step = wls.station_step
                step_completion_current = station_step.calculate_step_completion(pre_workflow_live_step, pre_workflow_live_step.step_completion, comp_attribute_value, lang_attribute_value)
                wls.eta = pre_workflow_live_step.step_completion
                wls.step_completion = step_completion_current
                wls.save!
            end
          else
            if pre_workflow_live_step.present? and pre_workflow_live_step.step_completion.present?
              if DateTime.parse(pre_workflow_live_step.step_completion.to_s) > DateTime.parse(wls.eta.to_s)
                station_step = wls.station_step
                step_completion_current = station_step.calculate_step_completion(pre_workflow_live_step, pre_workflow_live_step.step_completion, comp_attribute_value, lang_attribute_value)
                wls.eta = pre_workflow_live_step.step_completion
                wls.step_completion = step_completion_current
                wls.save!
              end
            end
          end
        end
      end
    end
    
    def additional_info_params
      params.require(:additional_info).permit(:object_id, :object_type, :status,
       :workflow_station_id, :info_timestamp, :work_flow_id, :note, :user_id, :reason_code_id)
    end
    def additional_info_params_note_only
      params.require(:additional_info).permit(:object_id, :object_type,
        :work_flow_id, :info_timestamp, :note, :user_id)
    end
    def rework_info_params
      params.require(:rework_info).permit(:object_id, :object_type, :reason ,:user_id ,:step_initiating_rework ,
        :rework_start_step)
    end
    def workflow_live_step_params
      params.require(:workflow_live_step).permit(:actual_confirmation)
    end

end
