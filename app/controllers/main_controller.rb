class MainController < ApplicationController
	skip_authorization_check

	def index

	end

   def open_modal
    respond_to do |format|
      format.html
      format.js
    end
   end

end
