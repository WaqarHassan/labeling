class OverviewController < ApplicationController
	skip_authorization_check
  
	def index
    @active_workflow = WorkFlow.find_by_is_active(true)
    @workflows = WorkFlow.where(is_active: false)
		@l1s = @active_workflow.l1s.where(is_active: true)
	end

   def open_info_modal
    @label_name = find_label_name('L2')
    @label_name2 = find_label_name('L3')
    @l2 = L2.find(params[:l2_id])
    respond_to do |format|
      format.html
      format.js
    end
   end

   def open_info_modal_l3
    @label_name = find_label_name('L3')
    @l3 = L3.find(params[:l3_id])
    respond_to do |format|
      format.html
      format.js
    end
   end

   def l1_status_popup

      @l1 = L1.find(params[:id])
      @label_name = find_label_name('L1')
      respond_to do |format|
      format.html
      format.js
    end
   end


   def open_rework_modal
     @label_name = find_label_name('L1')
      @label_name2 = find_label_name('L2')
       @label_name3 = find_label_name('L3')
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
     @label_name = find_label_name('L1')
      @label_name2 = find_label_name('L2')
       @label_name3 = find_label_name('L3')
    @wf_step_id = params[:wf_step_id]
    if params[:l2_id].present?
      @l2 = L2.find(params[:l2_id])
    end  
    respond_to do |format|
      format.html { render :partial => "confirm_modal" }
      format.js
    end
  end

  def update_workflow_status
    workflow_id = params[:workflow_id]
    WorkFlow.update_all(is_active: false)
    WorkFlow.update(workflow_id, is_active: true)
    redirect_to root_path, notice: 'WorkFlow was successfully changed.'
  end

  def update_task_confirmation
    @workflow_step = WorkflowStep.find(params[:id])
    params[:workflow_step][:actual_confirmation] = L1.set_db_datetime_format(params[:workflow_step][:actual_confirmation])
    @workflow_step.update(workflow_step_params)
    redirect_to root_path, notice: 'Status was successfully updated.'
  end

  def search
    q_string = '';
    # wildcard_bu = params[:wildcard][:bu]
    # if wildcard_bu.presence
    #   q_string += "bu like '%#{wildcard_bu}%'"
    # end
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

    # exact_bu = params[:exact][:bu]
    # if exact_bu.presence
    #   q_string += q_string != '' ? ' and ' : ''
    #   q_string += "bu = '#{exact_bu}'"
    # end

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

  @serach_result = ActiveRecord::Base.connection.select_all "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name 
                    from l1s, l2s, l3s 
                    where #{q_string} and l1s.id = l2s.l1_id and l2s.id = l3s.l2_id"

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    def workflow_step_params
      params.require(:workflow_step).permit(:actual_confirmation)
    end

end
