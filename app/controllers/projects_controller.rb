class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  skip_authorization_check
  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show


  end

  # GET /projects/new
  def new
    @workflow  = WorkFlow.where(is_active: true)

    @project = Project.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /projects/1/edit
  def edit
     @workflow  = WorkFlow.where(is_active: true)
     respond_to do |format|
      format.html
      format.js
    end


  end


  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      if @project.work_flow_id.present?
        templates = Template.where(work_flow_id: @project.work_flow_id)

        templates.each do |temp|
          WorkflowStep.create(step_id: temp.step_id, is_active: temp.is_active)
        end

      end
      redirect_to root_path, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to root_path, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:id, :name, :description, :user_id, :work_flow_id, :is_active)
    end
end
