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
			
			# 
			# * *Description* :
			#   - It is a backup function created by Developers.
			#
			def search_handoff_report(q_string)
  				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l1s.completed_actual as l1_completed_actual, l2s.completed_actual as l2_completed_actual,
  				 l3s.completed_actual as l3_completed_actual,l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s 
          				left join l2s on l1s.id = l2s.l1_id
          				left join l3s on l2s.id = l3s.l2_id and rework_parent_id IS NULL
       					where #{q_string} order by l1s.name"		
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end 
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It searches Objetcs with any Status.
			#     
			def search_handoff_exclude_complete(q_string)
  				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l1s.completed_actual as l1_completed_actual, l2s.completed_actual as l2_completed_actual, l3s.completed_actual as l3_completed_actual,
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s 
          				left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL 
          				left join l3s on l2s.id = l3s.l2_id and l3s.completed_actual IS NULL and rework_parent_id IS NULL
       					where #{q_string} and l1s.completed_actual IS NULL order by l1s.name"		
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It searches in main Objetcs whose Status is not Canceled.
			# 
			def search_handoff_exclude_cancel(q_string)
  				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name,l1s.completed_actual as l1_completed_actual, l2s.completed_actual as l2_completed_actual, l3s.completed_actual as l3_completed_actual,
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s 
          				left join l2s on l1s.id = l2s.l1_id and LOWER(l2s.status) != 'cancel' 
          				left join l3s on l2s.id = l3s.l2_id and LOWER(l3s.status) != 'cancel' and rework_parent_id IS NULL
       					where #{q_string} and LOWER(l1s.status) != 'cancel' order by l1s.name"		
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It searches Objetcs whose Status is neither Complete nor Canceled.
			# 
			def search_handoff_exclude_cancel_and_complete(q_string)
  				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l1s.completed_actual as l1_completed_actual, l2s.completed_actual as l2_completed_actual, l3s.completed_actual as l3_completed_actual,
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s 
          				left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL and LOWER(l2s.status) != 'cancel' 
          				left join l3s on l2s.id = l3s.l2_id and l2s.completed_actual IS NULL and LOWER(l3s.status) != 'cancel' and rework_parent_id IS NULL
       					where #{q_string} and l1s.completed_actual IS NULL and LOWER(l1s.status) != 'cancel' order by l1s.name"		
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It searches Objetcs for Handoff Report.
			# 
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
			# 
			# * *Arguments* :
			#   - Query String , workflow id
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for HandOff report for Objects whose Status is not Canceled.
			#
			def handoff_report_search_exclude_canceled(q_string, workflow)
				handoff_report__exclude_canceled_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
								l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,l1s.business_unit as l1_bu,l2s.business_unit as l2_bu,l3s.business_unit as l3_bu,
								l1s.status as l1_status,l2s.status as l2_status,l3s.status as l3_status,wls.station_step_id, wls.is_active,
								timestamp_logs.actual_confirmation,wls.eta, station_steps.step_name as step, workflow_stations.station_name as station, wls.id as wls_id, wls.object_type, timestamp_logs.id as log_id
								from l1s
								left join l2s on l1s.id = l2s.l1_id and LOWER(l2s.status) != 'cancel'
								left join l3s on l3s.l2_id=l2s.id and LOWER(l3s.status) != 'cancel'
								inner join workflow_live_steps as wls on (wls.object_id = l1s.id and wls.object_type = 'L1') 
								                               or (wls.object_id = l2s.id  and wls.object_type = 'L2') 
								                               or (wls.object_id = l3s.id  and wls.object_type = 'L3')
								inner join station_steps on wls.station_step_id = station_steps.id
								inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
								left join timestamp_logs on wls.id = timestamp_logs.workflow_live_step_id
								where #{q_string}
								and LOWER(l1s.status) != 'cancel' and wls.station_step_id in (select station_step_id from report_filter_steps where work_flow_id = #{workflow})
								order by l1s.name, l2s.name, l3s.name"
				handoff_report_serach_exclude_canceled_result = ActiveRecord::Base.connection.select_all handoff_report__exclude_canceled_sql_query
                return handoff_report_serach_exclude_canceled_result

			end
			# 
			# * *Arguments* :
			#   - Query String , workflow id
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for HandOff report for Objects whose Status is not Completed.

			def handoff_report_search_exclude_completed(q_string, workflow)
				handoff_report__exclude_canceled_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
								l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,l1s.business_unit as l1_bu,l2s.business_unit as l2_bu,l3s.business_unit as l3_bu,
								l1s.status as l1_status,l2s.status as l2_status,l3s.status as l3_status,wls.station_step_id, wls.is_active,
								timestamp_logs.actual_confirmation,wls.eta, station_steps.step_name as step, workflow_stations.station_name as station, wls.id as wls_id, wls.object_type, timestamp_logs.id as log_id
								from l1s
								left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL
								left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL and LOWER(l3s.status) != 'closed' 
								inner join workflow_live_steps as wls on (wls.object_id = l1s.id and wls.object_type = 'L1') 
								                               or (wls.object_id = l2s.id  and wls.object_type = 'L2') 
								                               or (wls.object_id = l3s.id  and wls.object_type = 'L3')
								inner join station_steps on wls.station_step_id = station_steps.id
								inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
								left join timestamp_logs on wls.id = timestamp_logs.workflow_live_step_id
								where #{q_string}
								and l1s.completed_actual IS NULL and wls.station_step_id in (select station_step_id from report_filter_steps where work_flow_id = #{workflow})
								order by l1s.name, l2s.name, l3s.name"
				handoff_report_serach_exclude_canceled_result = ActiveRecord::Base.connection.select_all handoff_report__exclude_canceled_sql_query
                return handoff_report_serach_exclude_canceled_result

			end
			# 
			# * *Arguments* :
			#   - Query String , workflow id
			# * *Returns* :
			#   - earch Results return by query
			# * *Description* :
			#   - It Searches data for HandOff report for Objects whose Status is neither Completed nor Canceled.
			#
			def handoff_report_search_exclude_canceled_completed(q_string, workflow)
				handoff_report__exclude_canceled_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
								l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,l1s.business_unit as l1_bu,l2s.business_unit as l2_bu,l3s.business_unit as l3_bu,
								l1s.status as l1_status,l2s.status as l2_status,l3s.status as l3_status,wls.station_step_id, wls.is_active,
								timestamp_logs.actual_confirmation,wls.eta, station_steps.step_name as step, workflow_stations.station_name as station, wls.id as wls_id, wls.object_type, timestamp_logs.id as log_id
								from l1s
								left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL and LOWER(l2s.status) != 'cancel'
								left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL and LOWER(l3s.status) != 'closed' and LOWER(l3s.status) != 'cancel'
								inner join workflow_live_steps as wls on (wls.object_id = l1s.id and wls.object_type = 'L1') 
								                               or (wls.object_id = l2s.id  and wls.object_type = 'L2') 
								                               or (wls.object_id = l3s.id  and wls.object_type = 'L3')
								inner join station_steps on wls.station_step_id = station_steps.id
								inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
								left join timestamp_logs on wls.id = timestamp_logs.workflow_live_step_id
								where #{q_string}
								and l1s.completed_actual IS NULL and LOWER(l1s.status) != 'cancel' and wls.station_step_id in (select station_step_id from report_filter_steps where work_flow_id = #{workflow})
								order by l1s.name, l2s.name, l3s.name"
				handoff_report_serach_exclude_canceled_result = ActiveRecord::Base.connection.select_all handoff_report__exclude_canceled_sql_query
                return handoff_report_serach_exclude_canceled_result

			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - Handoff report Status roll up.
			# 
			def get_rollUp_object_status(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id)
				status = "Closed"
				habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id}
				
				if habdoff_report_serach_unique.present?
					status = 'Active1'
					status = habdoff_report_serach_unique[0]['l3_status']
					habdoff_report_serach_unique_l3_with_partials = report_serach_result.select{|report| report['object_type'] == object_type and report['l3_name'].split('-R')[0] == habdoff_report_serach_unique[0]['l3_name']}
					if habdoff_report_serach_unique_l3_with_partials.present?
						status = 'Activeww'
						habdoff_report_serach_unique_l3_active_status = habdoff_report_serach_unique_l3_with_partials.select{|report| report['l3_status'].downcase == 'active' }
						if habdoff_report_serach_unique_l3_active_status.present?
							status = 'Active'
						else
							habdoff_report_serach_unique_l3_onHold_status = habdoff_report_serach_unique_l3_with_partials.select{|report| report['l3_status'].downcase == 'onhold' }
							if habdoff_report_serach_unique_l3_onHold_status.present?
								status = 'onHold'
							end
						end
					end
				end
				return status			
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It recalculate ETAs for HandOff report roll up.
			# 
			def get_time_stamp(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
				time_stamp = ""
				table_td_class = ""
				habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'] == station_step_id }
				if habdoff_report_serach_unique.present?
						if object_type == 'L3'
							habdoff_report_serach_unique_l3_with_partials = report_serach_result.select{|report| report['object_type'] == object_type and report['l3_name'].split('-R')[0] == habdoff_report_serach_unique[0]['l3_name'] and report['station_step_id'] == station_step_id }
							if habdoff_report_serach_unique_l3_with_partials.present?
								
								habdoff_report_serach_unique_l3_active = habdoff_report_serach_unique_l3_with_partials.select{|report| report['is_active'] == 1 }
								if habdoff_report_serach_unique_l3_active.present?
									habdoff_report_serach_unique_l3_blank = habdoff_report_serach_unique_l3_with_partials.select{|report| report['l3_status'].downcase != 'closed' and  report['actual_confirmation'] == nil }
									if habdoff_report_serach_unique_l3_blank.present?
										station_Step_to_calculate = filtered_station_steps.find_by_station_step_id(station_step_id)
										if station_Step_to_calculate.station_step.step_name.downcase == 'crb started'
											work_flow_id = station_Step_to_calculate.work_flow_id
											parent_l2s_of_l3 = L3.where(l2_id: parent_l2_id)
											bk_frm_collab_workflowLiveStep = []
											bk_frm_collab_workflowLiveStep_eta = []
											object_ids = ''
											parent_l2s_of_l3.each do |parent_l2_of_l3|
												object_ids = object_ids+','+parent_l2_of_l3.id.to_s
												bk_frm_collab_workflowLiveStep_result = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.object_type='L3' and workflow_live_steps.object_id=#{parent_l2_of_l3.id} and station_steps.step_name='Back from Collab.' and is_active=#{true} and actual_confirmation IS NOT NULL")
												bk_frm_collab_workflowLiveStep_eta_result = WorkflowLiveStep.joins(:station_step).where("workflow_live_steps.object_type='L3' and workflow_live_steps.object_id=#{parent_l2_of_l3.id} and station_steps.step_name='Back from Collab.' and is_active=#{true} and actual_confirmation IS NULL")
												if bk_frm_collab_workflowLiveStep_result.present?
													bk_frm_collab_workflowLiveStep << bk_frm_collab_workflowLiveStep_result.first
												end
												if bk_frm_collab_workflowLiveStep_eta_result.present?
													bk_frm_collab_workflowLiveStep_eta << bk_frm_collab_workflowLiveStep_eta_result.first
												end
											end
											if bk_frm_collab_workflowLiveStep.present? and bk_frm_collab_workflowLiveStep_eta.count == 0
												habdoff_report_actual = habdoff_report_serach_unique_l3_with_partials.select{|report| report['actual_confirmation'] == nil }
												if bk_frm_collab_workflowLiveStep.first.actual_confirmation.present? # and !habdoff_report_actual.present?
													object_ids = object_ids.split(",").map { |s| s.to_i }
													crd_started_workflowLiveStep = WorkflowLiveStep.where(object_type: 'L3', object_id: object_ids, station_step_id: station_step_id, is_active: true).maximum(:eta)
													if crd_started_workflowLiveStep.present?
														# Covnert minutes to hours and minutes
														workflow = WorkFlow.find_by_id(work_flow_id)
													  	BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
													    BusinessTime::Config.end_of_workday = workflow.end_of_workday

													    workflow.holidays.each do |holiday|
													       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
													    end
														number_days = 1
														actual_confirmation = crd_started_workflowLiveStep.to_time.strftime('%Y-%m-%d %H:%M')
														eta_datetime = Time.parse(actual_confirmation)
														if number_days > 0
															eta_datetime =  number_days.business_days.after(eta_datetime)
														end
														eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
														time_stamp = "ETA "+eta_date_stamp
														if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
															table_td_class = 'report_eta_light_red'
														end
													end	
												else
													calculated_eta = do_calculate_eta_for_l3(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
													time_stamp = calculated_eta[0]
													table_td_class = calculated_eta[1]
												end
											else
												calculated_eta = do_calculate_eta_for_l3(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
												time_stamp = calculated_eta[0]
												table_td_class = calculated_eta[1]
											end	
										else
											calculated_eta = do_calculate_eta_for_l3(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
											time_stamp = calculated_eta[0]
											table_td_class = calculated_eta[1]
										end
									else
										habdoff_report_serach_unique_l3_with_partials = habdoff_report_serach_unique_l3_with_partials.select{|actual| actual['actual_confirmation'] != nil }
										habdoff_report_actual_sorted = habdoff_report_serach_unique_l3_with_partials.sort_by { |h| h['actual_confirmation'] }.reverse!
										if habdoff_report_actual_sorted.present?
											time_stamp = habdoff_report_actual_sorted[0]['actual_confirmation'].strftime("%m/%d/%y")
										end
										table_td_class = 'report_actual_confirmation'
									end
								else
									time_stamp = 'N/A'
								end
							end
						else
							if habdoff_report_serach_unique[0]['is_active'] == 0
								time_stamp = 'N/A'
							else
								habdoff_report_actual = habdoff_report_serach_unique.select{|report| report['actual_confirmation'] != nil }
								if habdoff_report_actual.present?
									habdoff_report_actual_sorted = habdoff_report_actual.sort_by { |h| h['log_id'] }.reverse!
									time_stamp = habdoff_report_actual_sorted[0]['actual_confirmation'].strftime("%m/%d/%y")
									table_td_class = 'report_actual_confirmation'
								else
									calculated_eta = do_calculate_eta(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
									time_stamp = calculated_eta[0]
									table_td_class = calculated_eta[1]
								end
							end	
						end	
					#end	
				end
				return [time_stamp, table_td_class]
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It searches Objetcs with any Status.
			# 
			def do_calculate_eta_for_l3(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
				time_stamp = ""
				table_td_class = ""
				max_eta_datetime = nil
				filteredStationStep = filtered_station_steps.find_by_station_step_id(station_step_id)
				if filteredStationStep.predecessors.present?
					predecessors_list = filteredStationStep.predecessors.split(',')
					if predecessors_list.presence
						max_eta_datetime = nil
						predecessors_list.each do |pred|
							pred_habdoff_report_serach_unique = []
							pred_filteredStationStep = filtered_station_steps.find_by_station_step_id(pred)
							workflow = WorkFlow.find_by_id(pred_filteredStationStep.work_flow_id)

							pred_habdoff_report_serach_unique_current = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'].to_i == pred.to_i }
							if pred_habdoff_report_serach_unique_current.present?
								pred_habdoff_report_serach_unique_current.each do |phrsuc|
									pred_habdoff_report_serach_unique << phrsuc
								end
							end

							if ll_id == 'l3_id'
								if pred_habdoff_report_serach_unique_current.present?
									l3_object_id = pred_habdoff_report_serach_unique_current.first
									habdoff_report_serach_unique_l3_with_partials = report_serach_result.select{|report| report['object_type'] == object_type and report['l3_name'].split('-R')[0] == l3_object_id['l3_name'] and report['station_step_id'].to_i == pred.to_i }
									if habdoff_report_serach_unique_l3_with_partials.present?
										habdoff_report_serach_unique_l3_with_partials.each do |phrsup|
											pred_habdoff_report_serach_unique << phrsup
										end
									end
								end
								pred_habdoff_report_serach_unique_l3_id = report_serach_result.select{|report| report['object_type'] == 'L2' and report['l2_id'] == parent_l2_id and report['station_step_id'].to_i == pred.to_i }
								if pred_habdoff_report_serach_unique_l3_id.present?
									pred_habdoff_report_serach_unique_l3_id.each do |phrsul3|
										pred_habdoff_report_serach_unique << phrsul3
									end
								end
							end

							if ll_id == 'l2_id' or ll_id == 'l3_id'
								pred_habdoff_report_serach_unique_l2 = report_serach_result.select{|report| report['object_type'] == 'L1' and report['l1_id'] == parent_l1_id and report['station_step_id'].to_i == pred.to_i }
								if pred_habdoff_report_serach_unique_l2.present?
									pred_habdoff_report_serach_unique_l2.each do |phrsul2|
										pred_habdoff_report_serach_unique << phrsul2
									end
								end
							end
						
							habdoff_report_serach_unique_l3_blank = pred_habdoff_report_serach_unique.select{|report| report['l3_status'].downcase != 'closed' and report['actual_confirmation'] == nil }
							if !habdoff_report_serach_unique_l3_blank.present?
								pred_habdoff_report_serach_unique = pred_habdoff_report_serach_unique.select{|actual| actual['actual_confirmation'] != nil }
								habdoff_report_actual_sorted = pred_habdoff_report_serach_unique.sort_by { |h| h['actual_confirmation'] }.reverse
								actual_confirmation = habdoff_report_actual_sorted[0]['actual_confirmation']
									# Covnert minutes to hours and minutes
							  	BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
							    BusinessTime::Config.end_of_workday = workflow.end_of_workday

							    workflow.holidays.each do |holiday|
							       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
							    end
								number_days = pred_filteredStationStep.duration_days
								actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
								eta_datetime = Time.parse(actual_confirmation)
								
								if number_days > 0
									eta_datetime =  number_days.business_days.after(eta_datetime)
								end
								
								if !max_eta_datetime.present?
									max_eta_datetime = eta_datetime
								end
								if max_eta_datetime.present?
									if DateTime.parse(eta_datetime.to_s) > DateTime.parse(max_eta_datetime.to_s)
							      		max_eta_datetime = eta_datetime
							      	end	
								end

								eta_date_stamp = max_eta_datetime.strftime("%m/%d/%y")
								time_stamp = "ETA "+eta_date_stamp
								if DateTime.parse(Time.now.to_s) > DateTime.parse(max_eta_datetime.to_s)
									table_td_class = 'report_eta_light_red'
								end
							end

						end
					end
				end

				return [time_stamp, table_td_class]
			end
			# -------------end of HAND OFF work--------------------

			# -------------entire report serach------------------

			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results returned by query
			# * *Description* :
			#   - It searches data for Entire History report.
			#
			def entire_report_search(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
				l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
							l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,
							timestamp_logs.actual_confirmation, station_steps.step_name as step, 
							workflow_stations.station_name as station,workflow_live_steps.id as wls_id, 
							workflow_live_steps.object_type, timestamp_logs.id as log_id
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
			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for Entire History report for Objects whose Status is not Complete.
			#
			def entire_report_search_exclude_complete(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
				l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
							l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,
							timestamp_logs.actual_confirmation, station_steps.step_name as step, 
							workflow_stations.station_name as station,workflow_live_steps.id as wls_id, 
							workflow_live_steps.object_type, timestamp_logs.id as log_id
							from l1s
							left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL 
							left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL 
							inner join workflow_live_steps on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							                               or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							                               or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
							inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
							inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
							inner join timestamp_logs on workflow_live_steps.id = timestamp_logs.workflow_live_step_id
           					where #{q_string} and l1s.completed_actual IS NULL 
           					order by l1s.name, l2s.name, l3s.name"
				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end
			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for Entire History report for Objects whose Status is not Cancel.
			#
			def entire_report_search_exclude_cancel(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
				l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
							l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,
							timestamp_logs.actual_confirmation, station_steps.step_name as step, 
							workflow_stations.station_name as station,workflow_live_steps.id as wls_id, 
							workflow_live_steps.object_type, timestamp_logs.id as log_id
							from l1s
							left join l2s on l1s.id = l2s.l1_id and LOWER(l2s.status) != 'cancel'
							left join l3s on l3s.l2_id=l2s.id and LOWER(l3s.status) != 'cancel'
							inner join workflow_live_steps on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							                               or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							                               or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
							inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
							inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
							inner join timestamp_logs on workflow_live_steps.id = timestamp_logs.workflow_live_step_id
           					where #{q_string} and LOWER(l1s.status) != 'cancel' 
           					order by l1s.name, l2s.name, l3s.name"
				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end
			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It Searches data for Entire History report for Objects whose Status is neither Complete nor Cancel.
			#
			def entire_report_search_exclude_cancel_and_complete(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
				l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
							l2s.num_component as l2_num_component,l1s.num_component as l1_num_component,
							timestamp_logs.actual_confirmation, station_steps.step_name as step, 
							workflow_stations.station_name as station,workflow_live_steps.id as wls_id, 
							workflow_live_steps.object_type, timestamp_logs.id as log_id
							from l1s
							left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL and LOWER(l2s.status) != 'cancel'
							left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL and LOWER(l3s.status) != 'cancel'
							inner join workflow_live_steps on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							                               or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							                               or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
							inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
							inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
							inner join timestamp_logs on workflow_live_steps.id = timestamp_logs.workflow_live_step_id
           					where #{q_string} and l1s.completed_actual IS NULL and LOWER(l1s.status) != 'cancel' 
           					order by l1s.name, l2s.name, l3s.name"
				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end
			# -------------end entire report serach---------------------
			# 
			# * *Arguments* :
			#   - report_serach_result, object_type, object_id, ll_id
			# * *Returns* :
			#   - unique collection of search result 
			# * *Description* :
			#   - It makes collection unique based upon passed l1s id.
			#
			def do_search_report (report_serach_result, object_type, object_id, ll_id)
				report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id }
				return report_serach_unique.uniq{|x| x['log_id']}
			end

			# -------------current report serach---------------------


			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for Current Status report.
			#
			def current_report_search(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name,l2s.id as l2_id, l2s.name as l2_name, 
									l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
									workflow_live_steps.actual_confirmation as actual_confirmation, workflow_live_steps.eta as eta, 
									station_steps.step_name as step, workflow_stations.station_name as station, workflow_live_steps.id as wls_id, workflow_live_steps.object_type as object_type
									from l1s
									left join l2s on l1s.id = l2s.l1_id
									left join l3s on l3s.l2_id=l2s.id
									inner join workflow_live_steps 
										on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							            or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							            or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
									inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
									inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
           							where #{q_string} 
           							order by l1s.name, l2s.name, l3s.name"

				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end 

			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for Current Status Report for Objects whose Status is not Complete.
			#
			def current_report_search_exclude_complete(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name,l2s.id as l2_id, l2s.name as l2_name, 
									l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
									workflow_live_steps.actual_confirmation as actual_confirmation, workflow_live_steps.eta as eta, 
									station_steps.step_name as step, workflow_stations.station_name as station, workflow_live_steps.id as wls_id, workflow_live_steps.object_type as object_type
									from l1s
									left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL
									left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL
									inner join workflow_live_steps 
										on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							            or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							            or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
									inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
									inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
           							where #{q_string} and l1s.completed_actual IS NULL 
           							order by l1s.name, l2s.name, l3s.name"

				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end 
			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches data for Current Status Report for Objects whose Status is not Cancel
			#
			def current_report_search_exclude_cancel(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name,l2s.id as l2_id, l2s.name as l2_name, 
									l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
									workflow_live_steps.actual_confirmation as actual_confirmation, workflow_live_steps.eta as eta, 
									station_steps.step_name as step, workflow_stations.station_name as station, workflow_live_steps.id as wls_id, workflow_live_steps.object_type as object_type
									from l1s
									left join l2s on l1s.id = l2s.l1_id and LOWER(l2s.status) != 'cancel'
									left join l3s on l3s.l2_id=l2s.id and LOWER(l3s.status) != 'cancel'
									inner join workflow_live_steps 
										on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							            or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							            or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
									inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
									inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
           							where #{q_string} and LOWER(l1s.status) != 'cancel' 
           							order by l1s.name, l2s.name, l3s.name"

				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end 
			# 
			# * *Arguments* :
			#   - Query String 
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It Searches data for Current Status Report for Objects whose Status is neither Complete not Cancel
			#
			def current_report_search_exclude_cancel_and_complete(q_string)
				report_sql_query = "Select l1s.id as l1_id, l1s.name as l1_name,l2s.id as l2_id, l2s.name as l2_name, 
									l3s.id as l3_id, l3s.name as l3_name,l3s.num_component as l3_num_component,
									workflow_live_steps.actual_confirmation as actual_confirmation, workflow_live_steps.eta as eta, 
									station_steps.step_name as step, workflow_stations.station_name as station, workflow_live_steps.id as wls_id, workflow_live_steps.object_type as object_type
									from l1s
									left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL and LOWER(l2s.status) != 'cancel'
									left join l3s on l3s.l2_id=l2s.id and l3s.completed_actual IS NULL and LOWER(l3s.status) != 'cancel'
									inner join workflow_live_steps 
										on (workflow_live_steps.object_id = l1s.id and workflow_live_steps.object_type = 'L1') 
							            or (workflow_live_steps.object_id = l2s.id  and workflow_live_steps.object_type = 'L2') 
							            or (workflow_live_steps.object_id = l3s.id  and workflow_live_steps.object_type = 'L3')
									inner join station_steps on workflow_live_steps.station_step_id = station_steps.id
									inner join workflow_stations on station_steps.workflow_station_id = workflow_stations.id
           							where #{q_string} and l1s.completed_actual IS NULL and LOWER(l1s.status) != 'cancel' 
           							order by l1s.name, l2s.name, l3s.name"

				report_serach_result = ActiveRecord::Base.connection.select_all report_sql_query
                return report_serach_result
			end 
			# 
			# * *Arguments* :
			#   - report_serach_result, object_type, object_id, ll_id
			# * *Returns* :
			#   - Search Results return by query
			# * *Description* :
			#   - It searches Latest confirmation from the provided collection of search results
			#
			def do_current_search_report (report_serach_result, object_type, object_id, ll_id)
				report_serach_confirmation = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id }

				 actual_confirmation_row = report_serach_confirmation.select{|ac| ac['actual_confirmation'].present? }

				 if actual_confirmation_row.present?
				 	aa =  actual_confirmation_row.sort_by { |k| k["wls_id"] }.reverse.first

				 else
				 	aa =  report_serach_confirmation.sort_by { |k| k["wls_id"] }.first
				 end
				 return aa
 	
			end
			# -------------end current report serach--------------------- 
			# 
			# * *Arguments* :
			#   - report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps
			# * *Returns* :
			#   - timestamp containing calculated ETA and a respective table data color value.
			# * *Description* :
			#   - It calculate ETA for the HandOff report data.
			#
			def do_calculate_eta(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
				time_stamp = ""
				table_td_class = ""
				filteredStationStep = filtered_station_steps.find_by_station_step_id(station_step_id)
				if filteredStationStep.predecessors.present?
					predecessors_list = filteredStationStep.predecessors.split(',')
					if predecessors_list.presence
						max_eta_datetime = nil
						predecessors_list.each do |pred|
							pred_filteredStationStep = filtered_station_steps.find_by_station_step_id(pred)
							workflow = WorkFlow.find_by_id(pred_filteredStationStep.work_flow_id)
							pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'].to_i == pred.to_i }
							if !pred_habdoff_report_serach_unique.present? and ll_id == 'l3_id'
								pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == 'L2' and report['l2_id'] == parent_l2_id and report['station_step_id'].to_i == pred.to_i }
							end

							if !pred_habdoff_report_serach_unique.present? and (ll_id == 'l2_id' or ll_id == 'l3_id')
								pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == 'L1' and report['l1_id'] == parent_l1_id and report['station_step_id'].to_i == pred.to_i }
							end

							pred_habdoff_report_actual = pred_habdoff_report_serach_unique.select{|report| report['actual_confirmation'] != nil }
							if pred_habdoff_report_actual.present?
								pred_habdoff_report_actual_sorted = pred_habdoff_report_actual.sort_by { |h| h['log_id'] }.reverse!
								actual_confirmation = pred_habdoff_report_actual_sorted[0]['actual_confirmation']

									# Covnert minutes to hours and minutes
							  	BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
							    BusinessTime::Config.end_of_workday = workflow.end_of_workday

							    workflow.holidays.each do |holiday|
							       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
							    end
								number_days = pred_filteredStationStep.duration_days
								actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
								eta_datetime = Time.parse(actual_confirmation)
								
								if number_days > 0
									eta_datetime =  number_days.business_days.after(eta_datetime)
								end
								
								if !max_eta_datetime.present?
									max_eta_datetime = eta_datetime
								end
								if max_eta_datetime.present?
									if DateTime.parse(eta_datetime.to_s) > DateTime.parse(max_eta_datetime.to_s)
							      		max_eta_datetime = eta_datetime
							      	end	
								end

								eta_date_stamp = max_eta_datetime.strftime("%m/%d/%y")
								eta_time_stamp = max_eta_datetime.strftime("%I:%M %p")
								time_stamp = "ETA "+eta_date_stamp+"<br />"+eta_time_stamp
								if DateTime.parse(Time.now.to_s) > DateTime.parse(max_eta_datetime.to_s)
									table_td_class = 'report_eta_light_red'
								end

							end
						end
					end
				end

				return [time_stamp, table_td_class]
			end

			def hide_object(report_serach_result, result, is_include_onhold)
				habdoff_report_l3_sttaus = report_serach_result.select{|report| report['l3_status'] != nil}
				habdoff_report_l3_with_partials = habdoff_report_l3_sttaus.select{|report| report['l3_status'].downcase != "onhold" and report['l3_name'].split('-R')[0] == result['l3_name']}
				if !habdoff_report_l3_with_partials.present? and !is_include_onhold and result['l3_status'].downcase == "onhold"
					return true
				end
			end

			def hide_completed_object(report_serach_result, result, is_include_completed)
				habdoff_report_l3_sttaus = report_serach_result.select{|report| report['l3_status'] != nil}
				habdoff_report_l3_with_partials = habdoff_report_l3_sttaus.select{|report| report['l3_status'].downcase != "closed" and report['l3_name'].split('-R')[0] == result['l3_name']}
				if !habdoff_report_l3_with_partials.present? and !is_include_completed and result['l3_completed_actual'].present? 
					return true
				end
			end
			# 
			# * *Description* :
			#   - It is a backup for get_time_stamp function.
			#
			def get_time_stamp__aaa(report_serach_result, object_type, object_id, parent_l2_id, parent_l1_id, ll_id, station_step_id, filtered_station_steps)
				time_stamp = ""
				table_td_class = ""
				habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'] == station_step_id }
				
				if habdoff_report_serach_unique.present?
					if habdoff_report_serach_unique[0]['is_active'] == 0
						time_stamp = 'N/A'
					else
						habdoff_report_actual = habdoff_report_serach_unique.select{|report| report['actual_confirmation'] != nil }
						if habdoff_report_actual.present?
							habdoff_report_actual_sorted = habdoff_report_actual.sort_by { |h| h['log_id'] }.reverse!
							time_stamp = habdoff_report_actual_sorted[0]['actual_confirmation'].strftime("%m/%d/%y")
							time_stamp += "<br />"+habdoff_report_actual_sorted[0]['actual_confirmation'].strftime("%I:%M %p")
							table_td_class = 'report_actual_confirmation'
						else
							filteredStationStep = filtered_station_steps.find_by_station_step_id(station_step_id)
							if filteredStationStep.predecessors.present?
								predecessors_list = filteredStationStep.predecessors.split(',')
								if predecessors_list.presence
									max_eta_datetime = nil
									predecessors_list.each do |pred|
										pred_filteredStationStep = filtered_station_steps.find_by_station_step_id(pred)
										workflow = WorkFlow.find_by_id(pred_filteredStationStep.work_flow_id)
										pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == object_type and report[ll_id] == object_id and report['station_step_id'].to_i == pred.to_i }
										if !pred_habdoff_report_serach_unique.present? and ll_id == 'l3_id'
											pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == 'L2' and report['l2_id'] == parent_l2_id and report['station_step_id'].to_i == pred.to_i }
										end

										if !pred_habdoff_report_serach_unique.present? and (ll_id == 'l2_id' or ll_id == 'l3_id')
											pred_habdoff_report_serach_unique = report_serach_result.select{|report| report['object_type'] == 'L1' and report['l1_id'] == parent_l1_id and report['station_step_id'].to_i == pred.to_i }
										end

										pred_habdoff_report_actual = pred_habdoff_report_serach_unique.select{|report| report['actual_confirmation'] != nil }
										if pred_habdoff_report_actual.present?
											pred_habdoff_report_actual_sorted = pred_habdoff_report_actual.sort_by { |h| h['log_id'] }.reverse!
											actual_confirmation = pred_habdoff_report_actual_sorted[0]['actual_confirmation']

												# Covnert minutes to hours and minutes
										  	BusinessTime::Config.beginning_of_workday = workflow.beginning_of_workday
										    BusinessTime::Config.end_of_workday = workflow.end_of_workday

										    workflow.holidays.each do |holiday|
										       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
										    end
											number_days = pred_filteredStationStep.duration_days
											actual_confirmation = actual_confirmation.to_time.strftime('%Y-%m-%d %H:%M')
											eta_datetime = Time.parse(actual_confirmation)
											
											if number_days > 0
												eta_datetime =  number_days.business_days.after(eta_datetime)
											end
											
											if !max_eta_datetime.present?
												max_eta_datetime = eta_datetime
											end
											if max_eta_datetime.present?
												if DateTime.parse(eta_datetime.to_s) > DateTime.parse(max_eta_datetime.to_s)
										      		max_eta_datetime = eta_datetime
										      	end	
											end

											eta_date_stamp = max_eta_datetime.strftime("%m/%d/%y")
											eta_time_stamp = max_eta_datetime.strftime("%I:%M %p")
											time_stamp = "ETA "+eta_date_stamp+"<br />"+eta_time_stamp
											if DateTime.parse(Time.now.to_s) > DateTime.parse(max_eta_datetime.to_s)
												table_td_class = 'report_eta_light_red'
											end

										end
									end
								end
							end	
						end	
					end		
				end
				return [time_stamp, table_td_class]
			end
			# 
			# * *Arguments* :
			#   - object_id, object_type
			# * *Returns* :
			#   - collection of Object Attributes
			# * *Description* :
			#   - It calculate all Attributes for the given lxs.
			#
			def object_attributes(object_id, object_type)
				return AttributeValue.eager_load(:label_attribute).where(object_id: object_id, object_type: object_type)
			end
			# 
			# * *Arguments* :
			#   - object_att_values, att_name
			# * *Returns* :
			#   - attribute value name
			# * *Description* :
			#   - It finds specific Attribute name's Value from the provided collection of Object Attributes.
			#
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
			# 
			# * *Arguments* :
			#   - report_serach_result, object_type, object_id, ll_id
			# * *Returns* :
			#   - unique results from the given colection
			# * *Description* :
			#   - It finds unique Objects from the given collection.
			#
			def get_work_live_step(report_serach_result, object_type, object_id, ll_id)
				reportSerachUnique = report_serach_result.find{|wl| wl['object_type'] == object_type and wl[ll_id] == object_id }
				return reportSerachUnique
			end

			# 
			# * *Arguments* :
			#   - query string
			# * *Returns* :
			#   - Daily report search result
			# * *Description* :
			#   - It calculates data for Daily report based upon given query string 
			#
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

			# -------------general search--------------------
			
			# 
			# * *Arguments* :
			#   - query string
			# * *Returns* :
			#   - search_result 
			# * *Description* :
			#   - It calculates data for the given query string.
			#
			def search(q_string)
				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
							l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
							l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
              				from l1s left join l2s on l1s.id = l2s.l1_id left join l3s on l2s.id = l3s.l2_id 
           					where #{q_string} order by l1s.name"
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Returns* :
			#   - search_result 
			# * *Description* :
			#   - It calculates data for the given query string fro Objects whose Status is not Canceled.
			#
			def search_exclude_cancel(q_string)
				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s left join l2s on l1s.id = l2s.l1_id and LOWER(l2s.status) != 'cancel' 
          				left join l3s on l2s.id = l3s.l2_id and LOWER(l3s.status) != 'cancel'
       					where #{q_string} and LOWER(l1s.status) != 'cancel' order by l1s.name"
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Returns* :
			#   - search_result 
			# * *Description* :
			#   - It calculates data for the given query string fro Objects whose Status is not Complete.
			#
			def search_exclude_complete(q_string)
				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL
          				left join l3s on l2s.id = l3s.l2_id and l3s.completed_actual IS NULL
       					where #{q_string} and l1s.completed_actual IS NULL order by l1s.name"
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Returns* :
			#   - search_result 
			# * *Description* :
			#   - It calculates data for the given query string for Objects whose Status is neither Canceled nor Complete
			#
			def search_exclude_cancel_and_complete(q_string)
				sql_query = "Select l1s.id as l1_id, l1s.name as l1_name, l2s.id as l2_id, l2s.name as l2_name, 
						l3s.id as l3_id, l3s.name as l3_name, l1s.status as l1_status, l2s.status as l2_status, l3s.status as l3_status,
						l1s.business_unit as l1_bu, l2s.business_unit as l2_bu, l3s.business_unit as l3_bu
          				from l1s left join l2s on l1s.id = l2s.l1_id and l2s.completed_actual IS NULL and LOWER(l2s.status) != 'cancel'
          				left join l3s on l2s.id = l3s.l2_id and l3s.completed_actual IS NULL and LOWER(l3s.status) != 'cancel'
       					where #{q_string} and l1s.completed_actual IS NULL and LOWER(l1s.status) != 'cancel' order by l1s.name"
				serach_result = ActiveRecord::Base.connection.select_all sql_query
                return serach_result
			end

			# -------------end general search--------------------

		end
end
	







