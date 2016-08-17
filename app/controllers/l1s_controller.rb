class L1sController < ApplicationController
  before_action :set_l1, only: [:show, :edit, :update, :destroy]
  skip_authorization_check
  # GET /l1s
  def index
    @l1s = L1.all
  end

  # GET /l1s/1
  def show

 
  end

  # GET /l1s/new
  def new
    @l1_bu = @workflow.l1_bu
    @bu_options = BuOption.where(recording_level: 'L1') 
   
    @action = 'ADD'
    @btn_action = 'SAVE'
    @bu_options = BuOption.where(recording_level: 'L1')
    @attr_list = @workflow.label_attributes.where(recording_level: 'L1', is_visible: true)
    @l1 = L1.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /l1s/1/edit
  def edit
    @l1_bu = @workflow.l1_bu
    @bu_options = BuOption.where(recording_level: 'L1')
    @action = 'UPDATE'
    @btn_action = 'UPDATE'
    @attr_list = @workflow.label_attributes.where(recording_level: 'L1', is_visible: true)
    @attr_values = @l1.attribute_values
    respond_to do |format|
      format.html
      format.js
    end


  end


  # POST /l1s
  def create
    
    @l1 = L1.new(l1_params)
    @l1.user_id = current_user.id
    if @l1.save!
      if params[:attr].present?
        AttributeValue.create_attribute_values(params[:attr], @l1, 'L1') 
      end
      @l1.work_flow.workflow_stations.order(:sequence).each do |station|
        station.station_steps.where(recording_level: 'L1').each do |stp|
          WorkflowLiveStep.create(station_step_id: stp.id, object_id: @l1.id, object_type: 'L1', is_active: nil , eta: '')
        end
      end

      if @l1.workflow_live_steps.present?
         workflow_step = @l1.workflow_live_steps.first
         if !workflow_step.actual_confirmation.present?
           session[:open_confirm_modal] = 'open_confirm_modal'
           session[:workflow_step_id] = workflow_step.id
         end  
       end
      session[:l_type] = 'l1'
      session[:l_id] = @l1.id
      redirect_to root_path, notice: @workflow.L1+' was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /l1s/1
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
      redirect_to root_path, notice: @workflow.L1+' was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /l1s/1
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
      params.require(:l1).permit(:id, :name, :description, :user_id, :work_flow_id, :is_active, :business_unit)
    end
end
