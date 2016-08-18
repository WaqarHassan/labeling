class OverviewController < ApplicationController
	skip_authorization_check
  
	def index
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
     
      
     if session[:l_type] == 'l1' 
        if session[:open_confirm_modal] != 'open_confirm_modal'
          session[:l_type] = nil
        end
    @l1s = L1.where(id: session[:l_id])
     elsif session['l_type'] == 'l2'

        if session[:open_confirm_modal] != 'open_confirm_modal'
          session[:l_type] = nil
        end

        @show_search_result_l2 = 'filter_type_l2'
        @l2_records = L2.where(id: session[:l_id])
        @l1s = L1.where(id: @l2_records.first.l1_id)
      elsif session[:l_type] == 'l3'
        if session[:open_confirm_modal] != 'open_confirm_modal'
          session[:l_type] = nil
        end
        @show_search_result_l2 = 'filter_type_l2' 
        @show_search_result_l3 = 'filter_type_l3' 
        l3 = L3.find(session[:l_id])
        ll2 = l3.l2
        @l3_records = L3.where(id: session[:l_id])
        @l2_records = L2.where(id: @l3_records.first.l2_id)
        @l1s = L1.where(id: @l2_records.first.l1_id)
      else
        @l1s = @workflow.l1s.where(is_active: true).order(:id)
       
      end
     

    if session[:wildcard] != '' && session[:wildcard] != nil
      @wildcard = session[:wildcard]
    end
    if session[:exact] != '' && session[:exact] != nil
      @exact = session[:exact]
    end
    if session[:q_string] != '' && session[:q_string] != nil
      q_string = session[:q_string]
      @serach_result = WorkFlow.search(q_string)
    end
	end

   def open_info_modal
    @l2 = L2.find(params[:l2_id])
    @additional_info = AdditionalInfo.new
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @info_status = @workflow.statuses.where(recording_level: 'L2')
    @additional_info_data = @workflow.additional_infos.where(object_id: @l2.id, object_type: 'L2').order(:id)
    respond_to do |format|
      format.html
      format.js
    end
   end

   def add_additional_info
      params[:additional_info][:info_timestamp] = L1.set_db_datetime_format(params[:additional_info][:info_timestamp])
      AdditionalInfo.create(additional_info_params)
      redirect_to root_path, notice: 'Additional Info was successfully created.'
   end
 
   def open_info_modal_l3
    @l3 = L3.find(params[:l3_id])
    respond_to do |format|
      format.html
      format.js
    end
   end

   def l1_status_popup
      @l1 = L1.find(params[:id])
      respond_to do |format|
      format.html
      format.js
    end
   end
 
  #GET rework Modal
   def open_rework_modal
    @wf_step_id = params[:wf_step_id]
     workflow_live_step = WorkflowLiveStep.find(@wf_step_id)

    @st_step = workflow_live_step.station_step.step_name
    @st_name = workflow_live_step.station_step.workflow_station.station_name
    @stations = WorkflowStation.where(work_flow_id: @wf_step_id)

    # if params[:l2_id].present?
    #   @l2 = L2.find(params[:l2_id])
    # end 
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
   def update_rework_modal

   end
    #GET task Confirmation
  def open_confirm_modal
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
    session[:q_string] = ''
    session[:wildcard] = ''
    session[:exact] = ''

    redirect_to root_path, notice: 'WorkFlow was successfully changed.'
  end

  #POST Task Confirmation
  def update_task_confirmation

    @workflow_step = WorkflowLiveStep.find(params[:id])
    params[:workflow_live_step][:actual_confirmation] = L1.set_db_datetime_format(params[:workflow_live_step][:actual_confirmation])
    @workflow_step.update(workflow_live_step_params)
    # if @workflow_step.object_type == 'l3'
    #   @workflow_step.l3.update(:is_active => true)

    #   #L3.updateL3.find(@workflow_step.object_id)
    # elsif @workflow_step.object_type == 'l2'
    #    @workflow_step.l2.update(:is_active => true)

    # else
    #    @workflow_step.l1.update(:is_active => true)
    # end
    redirect_to root_path, notice: 'Status was successfully updated.'
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

  def project_deatils_l1
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    l1_list = params[:l1_id].split('_')
    @l1s = L1.where(id: [l1_list])

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def project_deatils_l2
    @show_search_result_l2 = 'filter_type_l2' 
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @l2_records = L2.where(id: params[:l2_id])

    @l1s = L1.where(id: @l2_records.first.l1_id)

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def project_deatils_l3
    @show_search_result_l2 = 'filter_type_l2' 
    @show_search_result_l3 = 'filter_type_l3' 
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    l3 = L3.find(params[:l3_id])
    ll2 = l3.l2

    @l3_records = L3.where(id: params[:l3_id])
    @l2_records = L2.where(id: @l3_records.first.l2_id)
    @l1s = L1.where(id: @l2_records.first.l1_id)

    respond_to do |format|
      format.html
      format.js
    end 
  end

  def show_all_db
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @l1s = @workflow.l1s.where(is_active: true).order(:id)
    respond_to do |format|
      format.html
      format.js
    end 
    
  end

  def destroy_seaaion
    session[:q_string] = ''
    session[:wildcard] = ''
    session[:exact] = ''
    respond_to do |format|
      format.json {render :json=>'session_empty'}
    end
  end

  def update_task_confirmation
    actualConfirmation = params[:workflow_live_step][:actual_confirmation]
    actual_confirmation = L1.set_db_datetime_format(actualConfirmation)
    workflow_live_step = WorkflowLiveStep.find(params[:id])
    calculate_eta_completion(actual_confirmation, workflow_live_step)
    redirect_to root_path, notice: 'Step confirmation done'
  end

  private

    def calculate_eta_completion(actual_confirmation, workflow_live_step)
      comp_attribute_value = workflow_live_step.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Comp'").first
      lang_attribute_value = workflow_live_step.object.attribute_values.joins(:label_attribute).where("label_attributes.short_label='#Lang'").first
      
      station_step = workflow_live_step.station_step
      step_completion = station_step.calculate_step_completion(actual_confirmation, comp_attribute_value, lang_attribute_value)

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
                step_completion_current = station_step.calculate_step_completion(pre_workflow_live_step.step_completion, comp_attribute_value, lang_attribute_value)
                wls.eta = pre_workflow_live_step.step_completion
                wls.step_completion = step_completion_current
                wls.save!
            end
          else
            if pre_workflow_live_step.present? and pre_workflow_live_step.step_completion.present?
              if DateTime.parse(pre_workflow_live_step.step_completion.to_s) > DateTime.parse(wls.eta.to_s)
                station_step = wls.station_step
                step_completion_current = station_step.calculate_step_completion(pre_workflow_live_step.step_completion, comp_attribute_value, lang_attribute_value)
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
      params.require(:additional_info).permit(:object_id, :object_type, :status, :workflow_station_id, :info_timestamp, :work_flow_id, :note, :user_id)
    end

    def workflow_live_step_params
      params.require(:workflow_live_step).permit(:actual_confirmation)
    end

end
