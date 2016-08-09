class OverviewController < ApplicationController
	skip_authorization_check

	def index
    @active_workflow = WorkFlow.find_by_is_active(true)
    @workflows = WorkFlow.where(is_active: false)
		@l1s = @active_workflow.l1s.where(is_active: true)
	end

   def open_info_modal

    @ia = IaList.find(params[:ia_list_id])
    respond_to do |format|
      format.html
      format.js
    end
   end

   def open_info_modal_ecr

    @ecr = Ecr.find(params[:ecr_id])
    respond_to do |format|
      format.html
      format.js
    end
   end

   def project_status_popup

      @project = Project.find(params[:id])
      respond_to do |format|
      format.html
      format.js
    end
   end


   def open_rework_modal
    @wf_step_id = params[:wf_step_id]
    if params[:ia_list_id].present?
      @ia = IaList.find(params[:ia_list_id])
    end 
    respond_to do |format|
      format.html
      format.js
    end
   end
    
  def open_confirm_modal
    @wf_step_id = params[:wf_step_id]
    if params[:ia_list_id].present?
      @ia = IaList.find(params[:ia_list_id])
    end  
    respond_to do |format|
      format.html
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
    params[:workflow_step][:actual_confirmation] = Project.set_db_datetime_format(params[:workflow_step][:actual_confirmation])
    @workflow_step.update(workflow_step_params)
    redirect_to root_path, notice: 'Status was successfully updated.'
  end


  private
    def workflow_step_params
      params.require(:workflow_step).permit(:actual_confirmation)
    end

end
