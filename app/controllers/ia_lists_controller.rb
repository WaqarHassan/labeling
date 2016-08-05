class IaListsController < ApplicationController
  before_action :set_ia_list, only: [:show, :edit, :update, :destroy]
  skip_authorization_check

  # GET /ia_lists
  def index
    @ia_list = IaList.all
  end

  # GET /ia/1
  def show
  end

  # GET /ia/new
  def add_nested_ia
    
    @ia_list = IaList.find(params[:ia_id])
    @project = current_user.projects.all
    @show_projects = 'dropdown'
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /ia/new
  def new
    if params.has_key?(:project_id)
      @show_projects = 'readonly'
      @project = Project.find(params[:project_id])
    else 
      @show_projects = 'dropdown'
      @project = current_user.projects.all 
    end  
    @ia_list = IaList.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  # GET /ia/1/edit
  def edit
    @ia_list = IaList.find(params[:id])
    @project = current_user.projects.all
    @show_projects = 'dropdown'
    respond_to do |format|
      format.html
      format.js
    end

  end

  # POST /ia
  def create
    @ia_list = IaList.new(ia_list_params)

    if @ia_list.save
      if @ia_list.project.work_flow_id.present?
        templates = Template.joins(:step).where("templates.work_flow_id= #{@ia_list.project.work_flow_id} and steps.recording_level='IaList'")
        templates.each do |temp|
          transition = Transition.find_by_step_id_and_previous_step_id(temp.step_id, (temp.step_id - 1))
          if transition.present?
            stpduration = Time.now + transition.duration.hours
          else
            stpduration = Time.now  
          end
          WorkflowStep.create(step_id: temp.step_id, object_id: @ia_list.id, object_type: temp.step.recording_level, is_active: temp.is_active, eta: stpduration, project_id: @ia_list.project.id)
        end
      end

      redirect_to root_path, notice: 'Ia was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ia/1
  def update
    if @ia_list.update(ia_list_params)
      redirect_to root_path, notice: 'Ia was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ia/1
  def destroy
    @ia_list.destroy
    redirect_to ia_list_url, notice: 'Ia was successfully destroyed.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ia_list
      @ia_list_list = IaList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ia_list_params
      params.require(:ia_list).permit(:name, :project_id, :business_unit, :comp_count, :notes, :is_active, :requested_date, :to_be_approved_by, :translation)
    end
end
