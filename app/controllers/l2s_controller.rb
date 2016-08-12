class L2sController < ApplicationController
  before_action :set_l2, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /ia_lists
  def index
    @l2 = L2.all
  end

  # GET /ia/1
  def show
  end


  # GET /ia/new
  def new
    @attr_list = @workflow.label_attributes.where(recording_level: 'L2', is_visible: true)
    @action = 'ADD'
    if params.has_key?(:l1_id)
      @show_l1s = 'readonly'
      @l1 = L1.find(params[:l1_id])
    else 
      @show_l1s = 'dropdown'
      @l1 = @workflow.l1s.where(is_active: true) 
    end  
    @l2 = L2.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  # GET /ia/1/edit
  def edit
    @attr_list = @workflow.label_attributes.where(recording_level: 'L2', is_visible: true)
    @l2 = L2.find(params[:id])
    @action = 'UPDATE'
    @l1 = @l2.l1
    @show_l1s = 'dropdowddn'
    respond_to do |format|
      format.html
      format.js
    end

  end

  # POST /ia
  def create
    @l2 = L2.new(l2_params)

    if @l2.save!
      workflow_id = @l2.l1.work_flow_id
      l2_id = @l2.id

      if @l2.status != ''
        save_activity_log
      end 
      if params[:attr].present?
        params[:attr].each do |a|

        AttributeValue.create(:attribute_id => a[0] ,
                               :value => a[1] ,
                               :object_id => @l2.id ,
                               :object_type => 'L2')
        end
      end
  
      @l2.l1.work_flow.workflow_stations.each do |station|
        station.station_steps.where(recording_level: 'L2').each do |stp|
          WorkflowLiveStep.create(station_step_id: stp.id, object_id: @l2.id, object_type: 'L2', is_active: nil , eta: '')
        end
      end

      if @l2.workflow_live_steps.present? && @l2.status == 'accept'
        session[:open_confirm_modal] = 'open_confirm_modal'
        session[:workflow_step_id] = @l2.workflow_live_steps.first.id
        session[:l_number_id] = l2_id
      end

      redirect_to root_path, notice: 'Ia was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ia/1
  def update
    previous_status = @l2.status
    if @l2.update!(l2_params)
      save_activity_log(previous_status)
      redirect_to root_path, notice: 'Ia was successfully updated.'
      #params[:attr].each do |a|
       #   AttributeValue.find()
       # AttributeValue.create(:attribute_list_id => a[0] ,
       #                       :value => a[1] ,
       #                       :object_id => @l2.id ,
       #                       :object_type => 'L2')
    else
      render :edit
    end
  end

  # DELETE /ia/1
  def destroy
    @l2.destroy
    redirect_to l2_url, notice: 'Ia was successfully destroyed.'
  end
  private

    def save_activity_log(previous_status = '')
      if previous_status == '' || previous_status == 'reject' 
        current_status = params[:l2][:status] 
        ActivityLog.create(object_id: @l2.id,object_type: 'L2' , current_value: current_status,previous_value: previous_status, user_id: current_user.id)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_l2
      @l2 = L2.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l2_params
      params.require(:l2).permit(:name, :l1_id, :status, :business_unit, :notes, :is_active, :requested_date, :to_be_approved_by, :translation)
    end
end
