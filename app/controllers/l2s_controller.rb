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
  def add_nested_ia
    
    @l2 = L2.find(params[:ia_id])
    @l1 = current_user.l1s.where(is_active: true)
    @show_l1s = 'dropdown'
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /ia/new
  def new
     @action = 'ADD'
    if params.has_key?(:l1_id)
      @show_l1s = 'readonly'
      @l1 = L1.find(params[:l1_id])
    else 
      @show_l1s = 'dropdown'
      @l1 = current_user.l1s.where(is_active: true) 
    end  
    @l2 = L2.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  # GET /ia/1/edit
  def edit
    @action = 'UPDATE'
    @l2 = L2.find(params[:id])
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

    if @l2.save
      if @l2.l1.work_flow_id.present?
        templates = Template.joins(:step).where("templates.work_flow_id= #{@l2.l1.work_flow_id} and steps.recording_level='L2'")
        templates.each do |temp|
          transition = Transition.find_by_step_id_and_previous_step_id(temp.step_id, (temp.step_id - 1))
          if transition.present?
            stpduration = Time.now + transition.duration.hours
          else
            stpduration = Time.now  
          end
          WorkflowStep.create(step_id: temp.step_id, object_id: @l2.id, object_type: temp.step.recording_level, is_active: temp.is_active, eta: stpduration, l1_id: @l2.l1.id)
        end
      end

      redirect_to root_path, notice: 'Ia was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ia/1
  def update
    if @l2.update(l2_params)
      redirect_to root_path, notice: 'Ia was successfully updated.'
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
    # Use callbacks to share common setup or constraints between actions.
    def set_l2
      @l2 = L2.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l2_params
      params.require(:l2).permit(:name, :l1_id, :business_unit, :comp_count, :notes, :is_active, :requested_date, :to_be_approved_by, :translation)
    end
end
