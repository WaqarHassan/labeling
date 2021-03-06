class L1sController < ApplicationController
  before_action :set_l1, only: [:show, :edit, :update, :destroy]
  skip_authorization_check
  # GET /l1s
  #
  # * *Description* :
  #   - It selects all l1s.
  #
  def index
    @l1s = L1.all
  end

  # GET /l1s/1
  #
  # * *Description* :
  #   - It does noting.
  #
  def show

  
  end

  # GET /l1s/new
  #
  # * *Renders* :
  #   - It renders pop-up via new.js.erb
  #
  def new
    if current_user.is_admin
      @l1_bu = @workflow.l1_bu
      @l1_component = @workflow.l1_component
     
      @action = 'ADD'
      @btn_action = 'SAVE'
      @bu_options = @workflow.bu_options.where(recording_level: 'L1')
      @status_list = @workflow.statuses.where(recording_level: 'L1')
      @attr_list = @workflow.label_attributes.where(recording_level: 'L1', is_visible: true).order(:sequence)
      @l1 = L1.new
      respond_to do |format|
        format.html
        format.js
      end
    else
      redirect_to root_path, alert: "You don't have permission to perform this action!"  
    end    
  end

  # GET /l1s/1/edit
  #
  # * *Renders* :
  #   - It finds l1s of given id and then renders pop-up via edit.js.erb
  #
  def edit
    @l1_bu = @workflow.l1_bu
    @l1_component = @workflow.l1_component
    @bu_options = @workflow.bu_options.where(recording_level: 'L1')
    @action = 'UPDATE'
    @btn_action = 'UPDATE'
    @status_list = @workflow.statuses.where(recording_level: 'L1')
    @attr_list = @workflow.label_attributes.where(recording_level: 'L1', is_visible: true).order(:sequence)
    @attr_values = @l1.attribute_values
    respond_to do |format|
      format.html
      format.js
    end


  end

 
  
  # POST /l1s
  #
  # * *Description* :
  #   - It creates new l1s object, sets its predecessors, saves Attribute Values, creates Workflow Live Steps, and creates Additional Information about it.
  #
  def create
    
    name = L1.find_by_name(params[:l1][:name])
    if name.present? 
        respond_to do |format|
          format.json { render json: {status: 'failed', message: 'Validation Error: Name must be unique!', unique_error: 'unique_error'}, status: 200 }
        end
    else
      @l1 = L1.new(l1_params)
      @l1.user_id = current_user.id
      if @l1.save!
        if params[:attr].present?
          AttributeValue.create_attribute_values(params[:attr], @l1, 'L1') 
        end
        @l1.work_flow.workflow_stations.order(:sequence).each do |station|
          station.station_steps.where(recording_level: 'L1').order(:sequence).each do |stp|
            predecessors = Transition.where(station_step_id: stp.id)
            predecessors_step = ''
            predecessors.each do |pred|
              workflow_live_steps = WorkflowLiveStep.where(station_step_id: pred.previous_station_step_id, object_id: @l1.id, object_type: 'L1')
              workflow_live_steps.each do |wls|
                predecessors_step = predecessors_step+','+wls.id.to_s
              end
            end

            if predecessors_step != ''
              predecessors_step.slice!(0)
            end
            
            WorkflowLiveStep.create(station_step_id: stp.id, object_id: @l1.id, object_type: 'L1', predecessors: predecessors_step, is_active: true , eta: '')
          end
        end

        if @l1.workflow_live_steps.present?
           workflow_step = @l1.workflow_live_steps.first
           if !workflow_step.actual_confirmation.present?
             session[:open_confirm_modal] = 'open_confirm_modal'
             session[:workflow_step_id] = workflow_step.id
           end  
         end
        AdditionalInfo.create(work_flow_id: @workflow.id , object_id: @l1.id,object_type: 'L1' , status: @l1.status, user_id: current_user.id)

        session[:filter_object_type] = 'L1'
        session[:filter_object_id] = @l1.id
        redirect_to root_path, notice: @workflow.L1+' was successfully created.'
      else
        render :new
      end
    end  
  end

   # PATCH/PUT /l1s/1
  #
  # * *Description* :
  #   - It updates l1s of given Id , updates its Atttribute Values, and creates Additional Information about this update.
  #
  def update

    @l1.modified_by_user_id = current_user.id
    if @l1.update!(l1_params)
      if params[:attr].present?
        params[:attr].each do |att|
         attr_value_object = AttributeValue.find_by_label_attribute_id_and_object_id_and_object_type(att[0], @l1.id, 'L1')
          if attr_value_object.present?
            attr_value_object.value = att[1]
            attr_value_object.save!
          else
            AttributeValue.create_single_attribute_value(att[0], att[1], @l1, 'L1')   
          end
        end
      end  
     AdditionalInfo.create(work_flow_id: @workflow.id, object_id: @l1.id,object_type: 'L1' , status: @l1.status, user_id: current_user.id)

      redirect_to root_path, notice: @workflow.L1+' was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /l1s/1
  #
  # * *Description* :
  #   - It deletes l1s of given Id.
  #
  def destroy
    @l1.destroy
    redirect_to l1s_url, notice: @workflow.L1+' was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_l1
      @l1 = L1.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l1_params
      params.require(:l1).permit(:id, :name, :description,:status, :user_id, :work_flow_id, :business_unit, :num_component)
    end
end
