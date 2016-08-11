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
    @action = 'ADD'
    @btn_action = 'SAVE'
    @workflow  = WorkFlow.find_by_is_active(true)
    @label_name = @workflow.workflow_labels.find_by_label('L1')
    @attr_list = @workflow.attribute_lists.where(level: 'L1')
    
    @l1 = L1.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /l1s/1/edit
  def edit
    @action = 'UPDATE'
    @btn_action = 'UPDATE'

     @workflow  = WorkFlow.find_by_is_active(true)
     @label_name = @workflow.workflow_labels.find_by_label('L1')
     @attr_list = @workflow.attribute_lists.where(level: 'L2')
     respond_to do |format|
      format.html
      format.js
    end


  end


  # POST /l1s
  def create
    @l1 = 

    
    @l1 = L1.new(l1_params)

    if @l1.save!
      redirect_to root_path, notice: 'L1 was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /l1s/1
  def update
    if @l1.update!(l1_params)
      redirect_to root_path, notice: 'L1 was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /l1s/1
  def destroy
    @l1.destroy
    redirect_to l1s_url, notice: 'L1 was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_l1
      @l1 = L1.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l1_params
      params.require(:l1).permit(:id, :name, :description, :user_id, :work_flow_id, :is_active)
    end
end
