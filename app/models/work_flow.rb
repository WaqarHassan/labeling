class WorkFlow < ActiveRecord::Base
	has_many :l1s
	has_many :label_attributes
	has_many :workflow_stations
	has_many :bu_options
	has_many :statuses
	has_many :additional_infos

		class << self
			
			def search(q_string)
				  serach_result = ActiveRecord::Base.connection.select_all "Select l1s.id as l1_id,
				  															 l1s.name as l1_name, 
																			   l2s.id as l2_id,
																			    l2s.name as l2_name,
																			     l3s.id as l3_id,
																			      l3s.name as l3_name 
                  																  from l1s left join l2s on l1s.id = l2s.l1_id left join l3s on l2s.id = l3s.l2_id 
                   																	 where #{q_string} order by l1s.name"
                   return serach_result
			end

		end
end
