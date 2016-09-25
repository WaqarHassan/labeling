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
				return report_serach_unique.uniq{|x| x['log_id']}
			end

			def handoff_report_search(q_string, workflow)
				handoff_report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
								l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,l1s.business_unit as l1_bu,l2s.business_unit as l2_bu,l3s.business_unit as l3_bu,
								l1s.status as l1_status,l2s.status as l2_status,l3s.status as l3_status,wls.station_step_id, wls.is_active,
								timestamp_logs.actual_confirmation,wls.eta, station_steps.step_name as step, workflow_stations.station_name as station, wls.id as wls_id, wls.object_type, timestamp_logs.id as log_id
								from l1s
								left join l2s on l1s.id = l2s.l1_id
								left join l3s on l3s.l2_id=l2s.id
								inner join workflow_live_steps as wls on (wls.object_id = l1s.id and wls.object_type = 'L1') 
								                               or (wls.object_id = l2s.id  and wls.object_type = 'L2') 
								                               or (wls.object_id = l3s.id  and wls.object_type = 'L3')
								inner join station_steps on wls.station_step_id = station_steps.id
								inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
								left join timestamp_logs on wls.id = timestamp_logs.workflow_live_step_id
								where #{q_string}
								and wls.station_step_id in (select station_step_id from report_filter_steps where work_flow_id = #{workflow})
								order by l1s.name, l2s.name, l3s.name"
				handoff_report_serach_result = ActiveRecord::Base.connection.select_all handoff_report_sql_query
                return handoff_report_serach_result
			end

			def get_time_stamp (report_serach_result, object_type, object_id, ll_id,station_step_id)
				time_stamp = ''
				table_td_class = ''
				habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'] == station_step_id }
				
				if habdoff_report_serach_unique.present?
					if habdoff_report_serach_unique[0]['is_active'] == 0
						time_stamp = 'N/A'
					else	
						habdoff_report_actual = habdoff_report_serach_unique.select{|report| report['actual_confirmation'] != nil }
						if habdoff_report_actual.present?
							habdoff_report_actual_sorted = habdoff_report_actual.sort_by { |h| h[:log_id] }.reverse!
							time_stamp = habdoff_report_actual_sorted[0]['actual_confirmation'].strftime("%m/%d/%y %I:%M %p")
							table_td_class = 'report_actual_confirmation'
						else
							if habdoff_report_serach_unique[0]['eta'].present?
								time_stamp = habdoff_report_serach_unique[0]['eta'].strftime("%m/%d/%y %I:%M %p")
								time_stamp = 'ETA '+time_stamp
								if DateTime.parse(Time.now.to_s) > DateTime.parse(habdoff_report_serach_unique[0]['eta'].to_s)
									table_td_class = 'report_eta_light_red'
								end
							end	
						end	
					end		
				end
				return [time_stamp, table_td_class]
			end

			def object_attributes(object_id, object_type)
				return AttributeValue.eager_load(:label_attribute).where(object_id: object_id, object_type: object_type)
			end

			def get_object_attribute_value(object_att_values, att_name)
				att_value = ''
				if object_att_values.present?
					att_value_object = object_att_values.find{|att| att.label_attribute.short_label == att_name }
					if att_value_object.present?
						att_value = att_value_object.value
					end
				end	
				return att_value
			end

			def get_work_live_step(report_serach_result, object_type, object_id, ll_id)
				reportSerachUnique = report_serach_result.find{|wl| wl['object_type'] == object_type and wl[ll_id] == object_id }
				return reportSerachUnique
			end


			def daily_report_serach(q_string)
				daily_report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name, 
								station_steps.step_name as step, workflow_stations.station_name as station, wls.object_type, 
								timestamp_logs.actual_confirmation, timestamp_logs.updated_at, timestamp_logs.user_id, users.first_name as updated_by, timestamp_logs.id as log_id
								from l1s
								left join l2s on l1s.id = l2s.l1_id
								left join l3s on l3s.l2_id=l2s.id
								inner join workflow_live_steps as wls on (wls.object_id = l1s.id and wls.object_type = 'L1') 
								                               or (wls.object_id = l2s.id  and wls.object_type = 'L2') 
								                               or (wls.object_id = l3s.id  and wls.object_type = 'L3')
								inner join station_steps on wls.station_step_id = station_steps.id
								inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
								inner join timestamp_logs on wls.id = timestamp_logs.workflow_live_step_id
								inner join users on timestamp_logs.user_id = users.id
								where #{q_string}
								order by l1s.name, l2s.name, l3s.name"
				daily_report_serach_result = ActiveRecord::Base.connection.select_all daily_report_sql_query
                return daily_report_serach_result
			end
		end
end
