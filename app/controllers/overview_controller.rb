class OverviewController < ApplicationController
	skip_authorization_check

	def index
    @active_workflow = WorkFlow.find_by_is_active(true)
    @workflows = WorkFlow.where(is_active: false)
		@l1s = @active_workflow.l1s.where(is_active: true)
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
      @label_name = find_label_name('L1')
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


  private
    def workflow_step_params
      params.require(:workflow_step).permit(:actual_confirmation)
    end

end
