class ReasonCodeValue < ActiveRecord::Base
	belongs_to :object, polymorphic: true

	class << self

		def get_reason_code_values (object_id, object_type)
			qury = "select rcv.object_id, rcv.object_type, rcv.new_reason_code_id, nrc.parent_id, nrc.reason_code
					from reason_code_values rcv
					inner join new_reason_codes nrc on nrc.id = rcv.new_reason_code_id
					where rcv.object_id = #{object_id} and rcv.object_type = '#{object_type}'
					order by rcv.id"
			reason_codes = ActiveRecord::Base.connection.select_all qury
            return reason_codes			
		end	
	
	end
end
