class MainController < ApplicationController
	skip_authorization_check

	def index
		@projects = current_user.projects
	end

   def open_modal
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
   
   def open_modal2
    respond_to do |format|
      format.html
      format.js
    end
   end
    
  def open_modal3
      respond_to do |format|
      format.html
      format.js
    end
   end

end
