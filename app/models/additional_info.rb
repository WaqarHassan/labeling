class AdditionalInfo < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :workflow_station
	belongs_to :user
	belongs_to :work_flow
	belongs_to :reason_code

	class << self
			# 
  			# * *Parameter/Arguments* :
  			#   - It accepts string of  comma seperated reason codes
  			# * *Returns* :
  			#   - It returns an string of HTML embeded array of reasons 
  			# * *Description* :
  			#   - It accepts string of  comma seperated reason codes and 
  			#     converts it to an string of HTML embeded array of reasons 
  			#     to be displayed in reject reason Pop-up
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
