class MainController < ApplicationController
	skip_authorization_check

	def index
		@projects = current_user.projects.where(is_active: true)
	end

   def open_info_modal

    @ia = IaList.find(params[:ia_list_id])

    # if params[:popup] == 'add_info'
    #   @info_modal = 'additional_info'
    # elsif params[:popup] == 'rework'
    #   @info_modal = 'rework_info'
    # elsif params[:popup] == 'collab'
    #   @info_modal = 'collaboration'
    # end
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
    respond_to do |format|
      format.html
      format.js
    end
   end
    
  def open_confirm_modal
      respond_to do |format|
      format.html
      format.js
    end
   end

end
