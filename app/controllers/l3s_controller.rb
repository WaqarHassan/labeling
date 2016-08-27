class L3sController < ApplicationController
  before_action :set_l3, only: [:show, :edit, :update, :destroy]
   skip_authorization_check 
  # GET /l3s
  def index
    @l3s = L3.all
  end

  # GET /l3s/1
  def show
  end

  # GET /l3s/new
  def new
    @attr_list = @workflow.label_attributes.where(recording_level: 'L3', is_visible: true).order(:sequence)
    @action = 'ADD'
    @btn_action = 'SAVE'
    @l3_bu = @workflow.l3_bu
    @status_list = @workflow.statuses.where(recording_level: 'L3')
    @bu_options = @workflow.bu_options.where(recording_level: 'L3')
    if params.has_key?(:l2_id)
      @show_projects = 'readonly'
      @l2 = L2.find(params[:l2_id])
    else 
      @show_projects = 'dropdown'
      @l1 = @workflow.l1s.where(status: 'Active') 
    end 
   
    @l3 = L3.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /l3s/1/edit
  def edit
    @l3_bu = @workflow.l3_bu
    @bu_options = @workflow.bu_options.where(recording_level: 'L3')
    @l2 = @l3.l2
    @status_list = @workflow.statuses.where(recording_level: 'L3')
    @attr_list = @workflow.label_attributes.where(recording_level: 'L3', is_visible: true).order(:sequence)
    @attr_values = @l3.attribute_values
    @action = 'UPDATE'
    @btn_action = 'UPDATE'
    
    @show_projects = 'dropdowncxd'
    @l1 = @workflow.l1s.where(status: 'Active') 
      respond_to do |format|
        format.html
        format.js
      end
  end

  # POST /l3s
  def create
    @l3 = L3.new(l3_params)
    @l3.user_id = current_user.id
    if @l3.save!
      if params[:attr].present?
        AttributeValue.create_attribute_values(params[:attr], @l3, 'L3') 
      end 

      @l3.l2.l1.work_flow.workflow_stations.order(:sequence).each do |station|
        station.station_steps.where(recording_level: 'L3').order(:sequence).each do |stp|
          WorkflowLiveStep.create(station_step_id: stp.id, object_id: @l3.id, object_type: 'L3', is_active: nil , eta: '')
        end
      end
      AdditionalInfo.create(work_flow_id: @workflow.id, object_id: @l3.id,object_type: 'L3' , status: @l3.status, user_id: current_user.id)

       if @l3.workflow_live_steps.present?
         workflow_step = @l3.workflow_live_steps.first
         if !workflow_step.actual_confirmation.present?
           session[:open_confirm_modal] = 'open_confirm_modal'
           session[:workflow_step_id] = workflow_step.id
         end  
       end
          session[:filter_object_type] = 'L3'
          session[:filter_object_id] = @l3.id
      redirect_to root_path, notice: @workflow.L3+' was successfully created.'
    else
      render :new
    end
  end


  # PATCH/PUT /l3s/1
  def update
    @l3.modified_by_user_id = current_user.id
    if @l3.update!(l3_params)
      if params[:attr].present?
        params[:attr].each do |att|
         attr_value_object = AttributeValue.find_by_label_attribute_id_and_object_id_and_object_type(att[0], @l3.id, 'L3')
          if attr_value_object.present?
            attr_value_object.value = att[1]
            attr_value_object.save!
          else
            AttributeValue.create_single_attribute_value(att[0], att[1], @l3, 'L3')   
          end
        end
      end  
      AdditionalInfo.create(work_flow_id: @workflow.id, object_id: @l3.id,object_type: 'L3' , status: @l3.status, user_id: current_user.id)

      redirect_to root_path, notice: @workflow.L3+' was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /l3s/1
  def destroy
    @l3.destroy
    redirect_to l3s_url, notice: @workflow.L3+' was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_l3
      @l3 = L3.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l3_params
      params.require(:l3).permit(:id, :name, :status, :note, :l2_id, :business_unit)
    end
end
