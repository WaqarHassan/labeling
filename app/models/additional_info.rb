class AdditionalInfo < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :workflow_station
	belongs_to :user
	belongs_to :work_flow
	belongs_to :reason_code

	class << self
			# 
  			# * *Arguments* :
  			#   - It accepts string of  comma seperated Reason Codes
  			# * *Returns* :
  			#   - It returns an string of HTML embeded array of Reasons 
  			# * *Description* :
  			#   - It accepts string of  comma seperated Reason Codes and 
  			#     converts it to an string of HTML embeded array of Reasons 
  			#     to be displayed in Reject Reason Pop-up
 			#
			def get_reasons(reason_code_ids)
				reason_code_ids = reason_code_ids.split(',')
				reason = ReasonCode.where(id: reason_code_ids)
				data = ''
				reason.each do |t|
					data +=  t.reason + ',<br/>'
				end
				return data.chomp('<br/>')				#data.chop.chop.chop.chop.chop :) 
			end
	end
end
