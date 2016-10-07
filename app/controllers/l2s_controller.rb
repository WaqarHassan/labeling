class L2sController < ApplicationController
  before_action :set_l2, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /ia_lists
  #
  # * *Description* :
  #   - It selects all l2s.
  #
  def index
    @l2 = L2.all
  end

  # GET /ia/1
  #
  # * *Description* :
  #   - It does noting.
  #
  def show
  end


  # GET /ia/new
  #
  # * *Renders* :
  #   - It renders pop-up via new.js.erb.
  #
  def new
    @attr_list = @workflow.label_attributes.where(recording_level: 'L2', is_visible: true).order(:sequence)
    @action = 'ADD'
    @bu_options = @workflow.bu_options.where(recording_level: 'L2')
    @l2_bu = @workflow.l2_bu
    @l2_component = @workflow.l2_component
    if params.has_key?(:l1_id)
      @show_l1s = 'readonly'
      @l1 = L1.find(params[:l1_id])
    else 
      @show_l1s = 'dropdown'

      @l1 = @workflow.l1s.where(status: 'Active') 
    end  
    @l2 = L2.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  # GET /ia/1/edit
  #
  # * *Renders* :
  #   - It finds l2s of given id and then renders pop-up via edit.js.erb.
  #
  def edit
    
    @attr_list = @workflow.label_attributes.where(recording_level: 'L2', is_visible: true).order(:sequence)
    @attr_values = @l2.attribute_values
    @bu_options = @workflow.bu_options.where(recording_level: 'L2')
    @l2_bu = @workflow.l2_bu
    @l2_component = @workflow.l2_component
    @action = 'UPDATE'
    @l1 = @l2.l1
    @show_l1s = 'dropdowddn'
    respond_to do |format|
      format.html
      format.js
    end

  end

  # POST /ia
  #
  # * *Description* :
  #   - It creates new l2s, sets its Predecessors, saves its Attribute Values, creates Workflow Live Steps and creates Additional Information about it .
  #   - It checks whether requested date is possible to meet or not and shows repective message.
  #
  def create
     name = L2.find_by_name(params[:l2][:name])
    if name.present? 
        respond_to do |format|
          format.json { render json: {status: 'failed', message: 'Validation Error: Name must be unique!', unique_error: 'unique_error'}, status: 200 }
        end
    else

      ia_approval_date = calculate_Ia_approval_date
      @l2 = L2.new(l2_params)
      @l2.user_id = current_user.id
      @l2.latest_ia_approval_date = ia_approval_date
      if @l2.save!
        if params[:attr].present?
          AttributeValue.create_attribute_values(params[:attr], @l2, 'L2') 
        end 

        workflow_id = @l2.l1.work_flow_id
        l2_id = @l2.id
    
        @l2.l1.work_flow.workflow_stations.order(:sequence).each do |station|
          station.station_steps.where(recording_level: 'L2').order(:sequence).each do |stp|

            predecessors = Transition.where(station_step_id: stp.id)
            predecessors_step = ''
            predecessors.each do |pred|
              workflow_live_steps = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l2.id, object_type: 'L2')
              workflow_live_steps_l1 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l2.l1.id, object_type: 'L1')
              workflow_live_steps_l1.each do |wls_l1|
                workflow_live_steps << wls_l1
              end

              workflow_live_steps.each do |wls|
                predecessors_step = predecessors_step+','+wls.id.to_s
              end

            end

            if predecessors_step != ''
              predecessors_step.slice!(0)
            end
            WorkflowLiveStep.create(station_step_id: stp.id, object_id: @l2.id, object_type: 'L2', predecessors: predecessors_step, is_active: true , eta: '')
          end
        end

        #-----------------------start mising predecessors
        workflow_live_steps_empty_pred = WorkflowLiveStep.where(object_id: @l2.l1.id, object_type: 'L1')
        workflow_live_steps_empty_pred.each do |pred_stp|
          predecessors = Transition.where(station_step_id: pred_stp.station_step_id)
          predecessors_step_empty = ''
          workflow_live_steps_pred = []
          predecessors.each do |pred|
            workflow_live_steps_pred_l1 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l2.l1.id, object_type: 'L1')
            workflow_live_steps_pred_l1.each do |wlsp_l1|
              workflow_live_steps_pred << wlsp_l1
            end
            
            @l2.l1.l2s.each do |l1_l2|
              workflow_live_steps_pred_l2 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: l1_l2.id, object_type: 'L2')
              workflow_live_steps_pred_l2.each do |wlsp_l2|
                workflow_live_steps_pred << wlsp_l2
              end

              l1_l2.l3s.each do |l2_l3|
                workflow_live_steps_pred_l3 = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: l2_l3.id, object_type: 'L3')
                workflow_live_steps_pred_l3.each do |wlsp_l3|
                  workflow_live_steps_pred << wlsp_l3
                end

              end
            end

          end
          workflow_live_steps_pred.each do |wls|
            predecessors_step_empty = predecessors_step_empty+','+wls.id.to_s
          end

          if predecessors_step_empty != ''
            predecessors_step_empty.slice!(0)
          end
          pred_stp.update(predecessors: predecessors_step_empty)
        end
        #-----------------------end mising predecessors

        workflowLiveStep = WorkflowLiveStep.find_by_object_id_and_object_type(@l2.id,'L2')
        if workflowLiveStep.present?
          WorkflowLiveStep.get_steps_calculate_eta(workflowLiveStep, @workflow,current_user)
        end

         db_info_timestamp = nil
         accept_reject_date = params[:accept_reject_date]
         if accept_reject_date.present?
          db_info_timestamp = L1.set_db_datetime_format(accept_reject_date)
         end
         additional_info_id = AdditionalInfo.create(work_flow_id: @workflow.id, 
                                                    object_id: @l2.id,
                                                    object_type: 'L2' ,
                                                    status: @l2.status,
                                                    user_id: current_user.id,
                                                    info_timestamp: db_info_timestamp) 

         session[:additional_info_id] = additional_info_id.id


        if @l2.workflow_live_steps.present? && @l2.status.downcase == 'active'
          session[:open_confirm_modal] = 'open_confirm_modal'
          session[:workflow_step_id] = @l2.workflow_live_steps.first.id
        elsif @l2.status.downcase == 'rejected'
          session[:open_reason_modal] = 'open_reason_modal'
          session[:l2_id] = @l2.id
        end
        session[:filter_object_type] = 'L2'
        session[:filter_object_id] = @l2.id

        if DateTime.parse(ia_approval_date.to_s) < DateTime.now.strftime('%Y-%m-%d')
           
          redirect_to root_path, notice: @workflow.L2+' was successfully created.Based on your entries, the IA should have already been approved on '+ ia_approval_date.strftime('%Y-%m-%d')
        else
          
           redirect_to root_path, notice: @workflow.L2+' was successfully created.'
              
        end

      else
        render :new
      end
    end  
  end

  # PATCH/PUT /ia/1
  #
  # * *Description* :
  #   - It updates l2s of given id, updates its Atttribute Values, and creates Additional Information about it.
  #   - It checks whether requested date is possible to meet or not and shows respective message.
  #
  def update
    @l2.modified_by_user_id = current_user.id
    name = L2.where(name: params[:l2][:name]).where.not(id: params[:id]).first
    if name.present? 
        respond_to do |format|
          format.json { render json: {status: 'failed', message: 'Validation Error: Name must be unique!', unique_error: 'unique_error'}, status: 200 }
        end
    else
      previous_status = @l2.status
      ia_approval_date = calculate_Ia_approval_date
      @l2.latest_ia_approval_date = ia_approval_date
      if @l2.update!(l2_params)
        if params[:attr].present?
          params[:attr].each do |att|
           attr_value_object = AttributeValue.find_by_label_attribute_id_and_object_id_and_object_type(att[0], @l2.id, 'L2')
            if attr_value_object.present?
              attr_value_object.value = att[1]
              attr_value_object.save!
            else
              AttributeValue.create_single_attribute_value(att[0], att[1], @l2, 'L2')   
            end
          end
        end  

        if params[:l2][:status].present?
          time_stamp =  nil
          accept_reject_date = params[:accept_reject_date]
          if accept_reject_date.present?
            time_stamp =  L1.set_db_datetime_format(accept_reject_date)
          end
             additional_info_id = AdditionalInfo.create(work_flow_id: @workflow.id,
                                object_id: @l2.id,
                                object_type: 'L2' ,
                                status: @l2.status,
                                user_id: current_user.id,
                                info_timestamp: time_stamp)
             session[:additional_info_id] = additional_info_id.id
        end

        if previous_status.downcase == 'rejected' && @l2.status.downcase == 'active'
          session[:open_confirm_modal] = 'open_confirm_modal'
          session[:workflow_step_id] = @l2.workflow_live_steps.first.id
          session[:l_number_id] = @l2.id
        elsif params[:l2][:status].presence
          if params[:l2][:status].downcase == 'rejected'
            session[:open_reason_modal] = 'open_reason_modal'
            session[:l2_id] = @l2.id
          end
          
        end

        if DateTime.parse(ia_approval_date.to_s) < DateTime.now.strftime('%Y-%m-%d')
           
          redirect_to root_path, notice: @workflow.L2+' was successfully Updated .Based on your entries, the IA should have already been approved on '+ ia_approval_date.strftime('%Y-%m-%d')
        else
          
           redirect_to root_path, notice: @workflow.L2+' was successfully Updated.'
              
        end
      else
        render :edit
      end
    end
  end

  # DELETE /ia/1
  #
  # * *Description* :
  #   - It destroys l2s of given id.
  #
  def destroy
    @l2.destroy
    redirect_to l2_url, notice: @workflow.L2+' was successfully destroyed.'
  end
  private

    # Use callbacks to share common setup or constraints between actions.
    def set_l2
      @l2 = L2.find(params[:id])
    end
    # * *Description* :
    #   - It calculate Estimate Completion Date of currrent l2s object.
    #
    def calculate_Ia_approval_date

      @workflow.holidays.each do |holiday|
        BusinessTime::Config.holidays << Date.parse(holiday.holiday_date.to_s)
      end
      horw = 0
      translation = 0
      requested_date = L1.set_db_date_format(params[:attr][params[:l2][:requested_date_id]] )

      if params[:attr][params[:l2][:horw_id]].to_s == 'YES'
         horw = @workflow.horw_days
      end
      if params[:attr][params[:l2][:translation_id]].to_s == 'YES'
        translation = @workflow.translation_days.to_i
      end

      components = params[:l2][:num_component]
      
      components = components.to_i / 17 

      base_duration_days = @workflow.base_duration_days  + components.to_i

      total_days = base_duration_days + horw + translation
      
      requested_date = requested_date.to_time.strftime('%Y-%m-%d %H:%M')
      req_date = Time.parse(requested_date)
     
      estimated_date = total_days.business_days.before(req_date)
      return estimated_date

    end

    
    # Only allow a trusted parameter "white list" through.
    def l2_params
      params.require(:l2).permit(:name, :l1_id, :status, :business_unit, :num_component, :notes, :requested_date, :to_be_approved_by)
    end
end
