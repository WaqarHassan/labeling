class AdditionalInfo < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	belongs_to :workflow_station
	belongs_to :user
	belongs_to :work_flow
	belongs_to :reason_code
	has_many :reason_code_values, as: :object 

	attr_accessor :reason_code_value

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
				return data.chomp(',<br/>')				#data.chop.chop.chop.chop.chop :) 
			end

			def get_status(additional_info_data, indx)
				indx +=1
				until additional_info_data[indx].status.present?
					indx +=1
				end
				return additional_info_data[indx].status
			end
	end
end
