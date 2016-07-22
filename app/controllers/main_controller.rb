class MainController < ApplicationController
	skip_authorization_check

	def index
		@projects = current_user.projects
	end

   def open_modal
    @info_modal = 'rework_info'
    respond_to do |format|
      format.html
      format.js
    end
   end
   


end
