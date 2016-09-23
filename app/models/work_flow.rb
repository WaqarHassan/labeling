class WorkFlow < ActiveRecord::Base
	has_many :l1s
	has_many :label_attributes
	has_many :workflow_stations
	has_many :bu_options
	has_many :statuses
	has_many :additional_infos
	has_many :holidays
	has_many :reason_codes
	has_many :report_filter_steps

		class << self
			
			def search(q_string)
				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
							l3s.id as l3_id, l3s.name as l3_name 
              				from l1s left join l2s on l1s.id = l2s.l1_id left join l3s on l2s.id = l3s.l2_id 
           					where #{q_string} order by l1s.name"
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end

			def report_search(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
							l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,
							timestamp_logs.actual_confirmation, station_steps.step_name as step, workflow_stations.station_name as station, workflow_live_steps.id as wls_id, workflow_live_steps.object_type, timestamp_logs.id as log_id
							from l1s
							left join l2s on l1s.id = l2s.l1_id
							left join l3s on l3s.l2_id=l2s.id
							inner join workflow_live_steps on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							                               or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							                               or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
							inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
							inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
							inner join timestamp_logs on workflow_live_steps.id = timestamp_logs.workflow_live_step_id
           					where #{q_string} order by l1s.name, l2s.name, l3s.name"
				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end

			def do_search_report (report_serach_result, object_type, object_id, ll_id)
				report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id }
				return report_serach_unique.uniq{|x| x['actual_confirmation']}
			end
		end
end
