class OverviewController < ApplicationController
	skip_authorization_check
  
	def index
    @label_attributes = @workflow.label_attributes #.where(is_visible: true)
    @workflow_stations = @workflow.workflow_stations.where(is_visible: true).order(:sequence)
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
		@l1s = @workflow.l1s.where(is_active: true).order(:id)

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
    respond_to do |format|
      format.html
      format.js
    end
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


   def open_rework_modal
    @wf_step_id = params[:wf_step_id]
    if params[:l2_id].present?
      @l2 = L2.find(params[:l2_id])
    end 
    respond_to do |format|
      format.html
      format.js
    end
   end
    
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
    redirect_to root_path, notice: 'WorkFlow was successfully changed.'
  end

  def update_task_confirmation
    @workflow_step = WorkflowLiveStep.find(params[:id])
    params[:workflow_live_step][:actual_confirmation] = L1.set_db_datetime_format(params[:workflow_live_step][:actual_confirmation])
    @workflow_step.update(workflow_live_step_params)
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
    exact_l3 = params[:exact][:l3]
    if exact_l3.presence
      q_string += q_string != '' ? ' and ' : ''
      q_string += "l3s.name = '#{exact_l3}'"
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

  private
    def workflow_live_step_params
      params.require(:workflow_live_step).permit(:actual_confirmation)
    end

end
