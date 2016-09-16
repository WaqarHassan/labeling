class ReportsController < ApplicationController
	skip_authorization_check

	def index
	end

	def entire_history
		@workflows = WorkFlow.where(is_active: true, is_in_use: false)

	end

end
