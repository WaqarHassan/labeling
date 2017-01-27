class WorkFlow < ActiveRecord::Base
	has_many :l1s
	has_many :label_attributes
	has_many :workflow_stations
	has_many :bu_options
	has_many :statuses
	has_many :additional_infos
	has_many :holidays
	has_many :reason_codes
	has_many :new_reason_codes
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

			def get_rollUp_l3_status(data_set)
				statuses = []
				onHoldReasonids = []
				status = 'Closed'
				data_set.each do |data|
					l3_sttaus = data[9].downcase
					statuses << l3_sttaus
					if l3_sttaus == 'onhold'
						onHoldReasonids << data[27]
					end
				end

				if statuses.include? 'active'
					status = 'Active'
				elsif  statuses.include? 'onhold'
					status = 'onHold'
				end	
							
				return [status, onHoldReasonids]			
			end
			# 
			# * *Arguments* :
			#   - query string
			# * *Description* :
			#   - It recalculate ETAs for HandOff report roll up.
			# 

			def get_rollUp_l3_timestamps(dataSet, indx, pred_actual, workflow, number_days, holidays, pred_numb_comp, l3_status)
				max_date = 'N/A'
				max_date_for_succesr = ''
				max_date2 = ''
				
				pred_numb_comp = pred_numb_comp == '' ? 0 : pred_numb_comp
				add_extra_day = pred_numb_comp/17 
				number_days = add_extra_day + number_days

				any_active_step = dataSet.select{|eta| eta[indx].to_i != 0}
				if any_active_step.present?
					max_date = ''
				end

				any_eta_step = dataSet.select{|eta| eta[indx].to_i==1}
				if any_eta_step.present?
					pred_actual = DateTime.parse(pred_actual.to_s) rescue nil
					if pred_actual

					    holidays.each do |holiday|
					       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
					    end
						actual_confirmation = pred_actual.to_time.strftime('%Y-%m-%d %H:%M')
						eta_datetime = Time.parse(actual_confirmation)
						
						if number_days > 0
							eta_datetime =  number_days.business_days.after(eta_datetime)
						end

						eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
						max_date = "ETA "+eta_date_stamp
						if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
							table_td_class = 'report_eta_light_red'
						end
					end
				else
					ind = 0
					dataSet.each do |data|
						date_parsed = DateTime.parse(data[indx].to_s) rescue nil
						if date_parsed
							ind +=1
							if ind == 1
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date2 = date_parsed
								max_date_for_succesr = date_parsed
							elsif DateTime.parse(max_date2.to_s) < DateTime.parse(date_parsed.to_s)
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date_for_succesr = date_parsed
								max_date2 = date_parsed
							end

							table_td_class = 'report_actual_confirmation'		
						end
					end
				end
				
				if l3_status.downcase == 'onhold' and max_date.include? 'ETA'
					max_date = 'OnHold'
					table_td_class = ''
				end

				return [max_date, table_td_class, max_date_for_succesr]
			end

			def get_rollUp_l3_station8_timestamps(dataSet, indx, pred_actual, workflow, number_days, holidays, pred_numb_comp, eta_indx, l3_status)
				max_date = 'N/A'
				max_date_for_succesr = ''
				max_date2 = ''
				
				pred_numb_comp = pred_numb_comp == '' ? 0 : pred_numb_comp
				add_extra_day = pred_numb_comp/17 
				number_days = add_extra_day + number_days

				any_active_step = dataSet.select{|eta| eta[indx].to_i != 0}
				if any_active_step.present?
					max_date = ''
				end

				backFromCollab_has_any_unconfirm = dataSet.select{|eta| eta[17].to_i == 1}
				max_crb_with_etas_date = 0
				if !backFromCollab_has_any_unconfirm.present?
					crb_with_etas = dataSet.select{|eta| eta[eta_indx].to_i != 0 and eta[eta_indx].to_i != 1 and eta[indx].to_i==1}
					crb_with_etas_sorted = crb_with_etas.sort_by { |h| h[eta_indx] }.reverse
					if crb_with_etas_sorted.present?
						max_crb_with_etas = crb_with_etas_sorted.first
						max_crb_with_etas_date = max_crb_with_etas[eta_indx]
					end
				end

				any_eta_step = dataSet.select{|eta| eta[indx].to_i==1}
				pred_actual = DateTime.parse(pred_actual.to_s) rescue nil
				if any_eta_step.present? and pred_actual
					max_crb_with_etas_date = DateTime.parse(max_crb_with_etas_date.to_s) rescue nil
					if max_crb_with_etas_date
						number_days = 1
						eta_datetime =  number_days.business_days.after(max_crb_with_etas_date)
						eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
						max_date = "ETA "+eta_date_stamp
						if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
							table_td_class = 'report_eta_light_red'
						end
					else
						pred_actual = DateTime.parse(pred_actual.to_s) rescue nil
						if pred_actual

						    holidays.each do |holiday|
						       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
						    end
							actual_confirmation = pred_actual.to_time.strftime('%Y-%m-%d %H:%M')
							eta_datetime = Time.parse(actual_confirmation)
							
							if number_days > 0
								eta_datetime =  number_days.business_days.after(eta_datetime)
							end

							eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
							max_date = "ETA "+eta_date_stamp
							if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
								table_td_class = 'report_eta_light_red'
							end
						end
					end	
				else
					ind = 0
					dataSet.each do |data|
						date_parsed = DateTime.parse(data[indx].to_s) rescue nil
						if date_parsed
							ind +=1
							if ind == 1
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date2 = date_parsed
								max_date_for_succesr = date_parsed
							elsif DateTime.parse(max_date2.to_s) < DateTime.parse(date_parsed.to_s)
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date_for_succesr = date_parsed
								max_date2 = date_parsed
							end

							table_td_class = 'report_actual_confirmation'		
						end
					end
				end

				if l3_status.downcase == 'onhold' and max_date.include? 'ETA'
					max_date = 'OnHold'
					table_td_class = ''
				end
				return [max_date, table_td_class, max_date_for_succesr]
			end

			def get_rollUp_l3_crb_started_timestamps_NA (ecr_inbox_date,actual_indx,workflow,holidays)
			    holidays.each do |holiday|
			       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
			    end

				if ecr_inbox_date == nil #|| result == '0'
					return ['N/A', ""]
				end
				na_eta = ''
				table_td_class = ''
				ecr_inbox_date_parsed = DateTime.parse(ecr_inbox_date.to_s) rescue nil
				if ecr_inbox_date_parsed
					to_crb = 2.business_days.after(ecr_inbox_date_parsed)

					if Date.parse(Time.now.to_s) > Date.parse(to_crb.to_s)
								table_td_class = 'report_eta_light_red'
							else
								table_td_class = ''
					end
					na_eta = 'ETA ' + to_crb.strftime("%m/%d/%y")	
				end	
				return 	[na_eta, table_td_class]

			end 
			
			def get_rollUp_l3_crb_started_timestamps_back_from_collab_NA(result19,workflow,holidays)

			    holidays.each do |holiday|
			       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
			    end
			    if result19 == nil #|| result == '0'
					return ['N/A', ""]
				end
				to_crb =  Date.parse(result19) + 1.day
				if Date.parse(Time.now.to_s) > Date.parse(to_crb.to_s)
					table_td_class = 'report_eta_light_red'
				else
					table_td_class = ''
				end
				return ['ETA ' + to_crb.strftime("%m/%d/%y"),table_td_class]

			end

			def get_rollUp_l3_crb_started_timestamps_back_from_collab_NA(result19,workflow,holidays)

			    holidays.each do |holiday|
			       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
			    end
			    if result19 == nil #|| result == '0'
					return ['N/A', ""]
				end

				eta_all_na = ''
				table_td_class = ''
				parsed_date = DateTime.parse(result[15].to_s) rescue nil
				if parsed_date
					to_crb =  Date.parse(parsed_date) + 1.day
					eta_all_na = 'ETA ' + to_crb.strftime("%m/%d/%y")
					if Date.parse(Time.now.to_s) > Date.parse(to_crb.to_s)
						table_td_class = 'report_eta_light_red'
					else
						table_td_class = ''
					end
				end
					
				return [eta_all_na,table_td_class]

			end

			def get_rollUp_l3_crb_started_timestamps(dataSet, eta_indx, actual_indx, sent_to_collab_actual,station8_sent_actual, 
				workflow, days_at_collab, days_at_station8, holidays,pred_numb_comp, l3_status)

			    holidays.each do |holiday|
			       BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
			    end
			    pred_numb_comp = pred_numb_comp == '' ? 0 : pred_numb_comp
			    add_extra_day = pred_numb_comp/17 
			    days_at_collab = days_at_collab + add_extra_day
			    days_at_station8 = days_at_station8 + add_extra_day

				max_date = 'N/A'
				max_date_for_succesr = ''
				max_date2 = ''
				table_td_class = ''
				pred_actuals = [sent_to_collab_actual, station8_sent_actual]
				pred_days = [days_at_collab, days_at_station8]

				any_active_step = dataSet.select{|eta| eta[actual_indx].to_i != 0}
				if any_active_step.present?
					max_date = ''
				end

				backFromCollab_has_any_unconfirm = dataSet.select{|eta| eta[17].to_i == 1}
				max_crb_with_etas_date = 0
				if !backFromCollab_has_any_unconfirm.present?
					crb_with_etas = dataSet.select{|eta| eta[eta_indx].to_i != 0 and eta[eta_indx].to_i != 1 and eta[actual_indx].to_i == 1}
					crb_with_etas_sorted = crb_with_etas.sort_by { |h| h[eta_indx] }.reverse
					if crb_with_etas_sorted.present?
						max_crb_with_etas = crb_with_etas_sorted.first
						max_crb_with_etas_date = max_crb_with_etas[eta_indx]
					end
				end

				any_eta_step = dataSet.select{|eta| eta[actual_indx].to_i==1}

				collab_pred_actual = DateTime.parse(sent_to_collab_actual.to_s) rescue nil
				sent_pred_actual = DateTime.parse(station8_sent_actual.to_s) rescue nil

				if any_eta_step.present? and (collab_pred_actual or sent_pred_actual)
					max_crb_with_etas_date = DateTime.parse(max_crb_with_etas_date.to_s) rescue nil
					if max_crb_with_etas_date
						number_days = 1
						eta_datetime =  number_days.business_days.after(max_crb_with_etas_date)
						eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
						max_date = "ETA "+eta_date_stamp
						if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
							table_td_class = 'report_eta_light_red'
						end
					else
						pred_actuals.each_with_index do |pred_actual, idx|
							pred_actual = DateTime.parse(pred_actual.to_s) rescue nil
							if pred_actual
								# Covnert minutes to hours and minutes
								actual_confirmation = pred_actual.to_time.strftime('%Y-%m-%d %H:%M')
								eta_datetime = Time.parse(actual_confirmation)
								number_days = pred_days[idx]
								if number_days > 0
									eta_datetime =  number_days.business_days.after(eta_datetime)
								end

								max_date2 = DateTime.parse(max_date2.to_s) rescue nil
								if idx == 0 or !max_date2
									eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
									max_date = "ETA "+eta_date_stamp
									if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
										table_td_class = 'report_eta_light_red'
									end
									max_date2 = eta_datetime
								elsif DateTime.parse(max_date2.to_s) < DateTime.parse(eta_datetime.to_s)
									eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
									max_date = "ETA "+eta_date_stamp
									if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
										table_td_class = 'report_eta_light_red'
									end
									max_date2 = eta_datetime
								end
							end
						end
					end		
				else
					ind = 0
					dataSet.each do |data|
						date_parsed = DateTime.parse(data[actual_indx].to_s) rescue nil
						if date_parsed
							ind +=1
							if ind == 1
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date2 = date_parsed
								max_date_for_succesr = date_parsed
							elsif DateTime.parse(max_date2.to_s) < DateTime.parse(date_parsed.to_s)
								max_date = date_parsed.strftime("%m/%d/%y")
								max_date_for_succesr = date_parsed
								max_date2 = date_parsed
							end

							table_td_class = 'report_actual_confirmation'
						end
					end
				end

				if max_date == ''
					max_crb_with_etas_date = DateTime.parse(max_crb_with_etas_date.to_s) rescue nil
					if max_crb_with_etas_date
						number_days = 1
						eta_datetime =  number_days.business_days.after(max_crb_with_etas_date)
						eta_date_stamp = eta_datetime.strftime("%m/%d/%y")
						max_date = "ETA "+eta_date_stamp
						if DateTime.parse(Time.now.to_s) > DateTime.parse(eta_datetime.to_s)
							table_td_class = 'report_eta_light_red'
						end
					end						
				end

				
				if l3_status.downcase == 'onhold' and max_date.include? 'ETA'
					max_date = 'OnHold'
					table_td_class = ''
				end

				return [max_date, table_td_class, max_date_for_succesr]
			end
			
			def getOnHoldNewReason(reason_codes)
				reason_string = ''
				reasons_array = []
				if reason_codes.present?
					reasons_list = reason_codes.split('|')
					reasons_list.each_slice(2) do |reason| 
						if reason.count > 1
							reasons_array << {'id' => reason[0], 'reason'=> reason[1], 'parent_id'=> nil}
						else
							reasons_array << {'id' => reason[0], 'reason'=> nil, 'parent_id'=> nil}
						end
					end  

					reasons_array.each_with_index do |reason_code, indx|
					ids_array = reason_code['id'].split('###')
					if ids_array.count > 1 or indx > 0
						parent_id = ids_array[0]
							if parent_id != '-'
							reasons_array[indx-1]['parent_id'] = parent_id
							end
						reason_code['id'] = ids_array[1]
						end
					end 
					
					main_reasons = reasons_array.select{|ra| ra['id']!=nil and ra['parent_id']==nil}
					main_reasons.each do |main_res|
						has_child = reasons_array.select{|ra| ra['id']!=nil and ra['parent_id']==main_res['id']}
						if has_child.present?
							has_child.each do |child|
								reason_string = reason_string+main_res['reason']+' > '+child['reason']+', '
							end
						else
							reason_string = reason_string+main_res['reason']+', '
						end
					end

					if reason_string != ''
						reason_string = reason_string.chomp(', ')
					end
				end
				return reason_string

			end

			def getOnHoldReason(reason_codes, reason_ids)
				reason_values = ''
				reason_ids_array = reason_ids.split('|')
				reason_ids_array.each do |resons|
					reason_selected = reason_codes.select{|res| res.id == resons.to_i}
					if reason_selected.present?
						reason_values = reason_values+reason_selected.first.reason+','
					end
				end
				if reason_values != ''
					reason_values = reason_values.chomp(",")
				end
				return reason_values
			end

			def getL3OnHoldReason(reason_codes, l3_reason_ids)
				reason_values = ''
				reason_values_array = []
				l3_reason_ids.each do |l3_reason|
					if l3_reason.presence
						reason_ids_array = l3_reason.split('|')
						reason_ids_array.each do |resons|
							reason_selected = reason_codes.select{|res| res.id == resons.to_i}

							if reason_selected.present?
								hold_reason = reason_selected.first.reason
								if reason_values_array.include? hold_reason
								else
									reason_values = reason_values+hold_reason+','
									reason_values_array << reason_selected.first.reason
								end
							end
						end
					end	
				end	
	
				if reason_values != ''
					reason_values = reason_values.chomp(",")
				end

				return reason_values
			end

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

			def hide_object(report_serach_result, result, is_include_onhold, is_include_completed)
				habdoff_report_l3_sttaus = report_serach_result.select{|report| report['l3_status'] != nil}
				habdoff_report_l3_with_partials = habdoff_report_l3_sttaus.select{|report| report['l3_status'].downcase != "onhold" and report['l3_name'].split('-R')[0] == result['l3_name']}
				if !habdoff_report_l3_with_partials.present? and !is_include_onhold and result['l3_status'].downcase == "onhold"
					return true
				elsif !is_include_onhold and !is_include_completed
					if !habdoff_report_l3_with_partials.present? and result['l3_status'].downcase == "closedvqdfgd"
						return true
					end
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

			def handoff_report_stored_procedure (bu, l1, l2, l3, include_completed, include_cancel, include_onhold)
				result = ActiveRecord::Base.connection.execute("call handoff_report('#{bu}', '#{l1}', '#{l2}', '#{l3}', #{include_completed}, #{include_cancel}, #{include_onhold})")
				return result
			end
			def data_feed_stored_procedure
				result =  ActiveRecord::Base.connection.execute("call data_feed()")
				return result
			end

			# 
			# * *Returns* :
			#   - search_result 
			# * *Description* :
			#   - Reject data report data
			#
			def reject_data_stored_procedure
				result =  ActiveRecord::Base.connection.execute("call reject_report()")
				return result
			end

			def to_csv(data_set)
				CSV.generate do |csv|
			      csv <<  ['Project', 'Proj-Status', 'Proj-Completed', 'IA', 'IA-Status', 'IA-Completed',
			      		 'BU', 'IA #Comp', 'ECR', 'ECR-Status', 'ECR-Completed', 'ECR #Comp', 'ParentId',
			      		  'Parent', 'IA Approved', 'ECR Inbox', 'Sent to Collab', 'Back from Collab', 
			      		  'Station8 Sent', 'CRB Started - ETA', 'CRB Started', 'ECN Released', 'Horw', 
			      		  '#Lang', 'CompType', 'MainRecord', 'IA-HoldReason','ECR-HoldReason', 'IncludeCompleted','Project-id', 'IA-id', 'ECR-id', 'Station8 Sent - ETA']
			      data_set.each do |report|
			        csv <<  [report[0], report[1], report[2], report[3], report[4], report[5], report[6], report[7], report[8], report[9], report[10], report[11], report[12], report[13], report[14], report[15], report[16], report[17], report[18], report[19], report[20], report[21], report[22], report[23], report[24], report[25], report[26], report[27], report[28], report[29], report[30], report[31], report[32]]
			      end
			    end
			end
			def to_csv_data_feed(data_set)
				CSV.generate do |csv|
			      csv <<  ['IA', 'IA-Status', 'IA-Completed', 'BU', 'IA-#Comp', 'Translation',
			      		  'HORW', 'RequestedBy', 'ECR', 'ECR-Status', 'ECR-Completed', 'Main',
			      		  'ECR-#Comp','IA Approved', 'Translation-Inbox', 'Translation-Start', 'Translation-End', 'ECR-Start', 
			      		  'Collab-Sent', 'Collab-Received', 'Design-Inbox', 'Station8-Inbox', 'Station8-Received', 'CRB-Started',
			      		  'CRB-Complete', 'ECR-Release','Group1','Group2' , 'Group3' , 'Group4',
			      		  'Group5' , 'ECR-Status' , 'Status-Timestamp' ,'Status Station', 'ecrid', 'ParentId',
			      		  'ECR Inbox', 'Rework Reason', 'Rework Station' ,'Status Reason' ,'CompType']
			      data_set.each do |report|
			        csv <<  [report[0], report[1], report[2], report[3], report[4], report[5], report[6], report[7], report[8], report[9], report[10], report[11], report[12], report[13], report[14], report[15], report[16], report[17], report[18], report[19], report[20],
			         report[21], report[22], report[23], report[24], report[25], report[26], report[27], report[28], report[29] , report[30], report[31], report[32], report[33], report[34], report[35], report[36], report[37], report[38], report[39], report[40] ]
			      end
			    end
			end

			def to_csv_reject_data(data_set)
				CSV.generate do |csv|
			      csv <<  ['name', 'business_unit', 'info_timestamp', 'Reasons', 'Reasons', 'note',
			      			 '# Rejects', 'num_component', 'status']
			      data_set.each do |report|
			        csv <<  [report[0], report[1], report[2], report[3], report[4], report[5], report[6], report[7], report[8]]
			      end
			    end
			end

			def default_wip_query(start_date , end_date)\
				result =  ActiveRecord::Base.connection.execute("call wip_report( '#{start_date}' , '#{end_date}' )")
				ActiveRecord::Base.clear_active_connections!
				return result
			end
			def default_wip()
				now = Date.parse(DateTime.now.to_s)
				default_values =[]
				sunday = now - now.wday 
				monday = sunday - 6
				default_values << [monday,sunday]

				table4 = default_wip_query(monday,sunday)
				sunday = monday -1
				monday  = sunday - 6
				default_values << [monday,sunday]

				table3 = default_wip_query(monday,sunday)
				sunday = monday -1
				monday  = sunday - 6
				default_values << [monday,sunday]

				table2 = default_wip_query(monday,sunday)
				sunday = monday -1
				monday  = sunday - 6
				default_values << [monday,sunday]

				table1 = default_wip_query(monday,sunday)
				ret = [default_values.reverse,table1.first ,table2.first , table3.first , table4.first]
				return ret

			end
			def rework_info_report_query(start_date , end_date)\
				result =  ActiveRecord::Base.connection.execute("call rework_report( '#{start_date}' , '#{end_date}' )")
				ActiveRecord::Base.clear_active_connections!
				return result
			end

		end
end


# 0 = 'Project'
# 1 = 'Proj-Status'
# 2 = 'Proj-Completed'
# 3 = 'IA'
# 4 = 'IA-Status'
# 5 = 'IA-Completed'
# 6 = 'BU'
# 7 = 'IA #Comp'
# 8 = 'ECR'
# 9 = 'ECR-Status'
# 10 = 'ECR-Completed'
# 11 = 'ECR #Comp'
# 12 = 'ParentId'
# 13 = 'Parent'
# 14 = 'IA Approved'
# 15 = 'ECR Inbox'
# 16 = 'Sent to Collab'
# 17 = 'Back from Collab'
# 18 = 'Station8 Sent'
# 19 = 'CRB Started - ETA'
# 20 = 'CRB Started'
# 21 = 'ECN Released'
# 22 = 'Horw', 
# 23 = '#Lang'
# 24 = 'CompType'
# 25 = 'MainRecord'
# 26 = 'IA-HoldReason'
# 27 = 'ECR-HoldReason'
# 28 = 'IncludeCompleted'
# 29 = 'Porject-Id'
# 30 = 'IA-id'
# 31 = 'ECR-id'
# 32 = 'Station8 Sent - ETA'





