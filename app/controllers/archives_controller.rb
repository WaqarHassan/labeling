class ArchivesController < ApplicationController
  before_action :set_archive, only: [:show, :edit, :update, :destroy]

  # GET /archives
  def index
    @archives = Archive.all
  end

  # GET /archives/1
  def show
  end

  # GET /archives/new
  def new
    @archive = Archive.new
  end

  # GET /archives/1/edit
  def edit
  end

  # POST /archives
  def create
    @archive = Archive.new(archive_params)

    if @archive.save
      redirect_to @archive, notice: 'Archive was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /archives/1
  def update
    if @archive.update(archive_params)
      redirect_to @archive, notice: 'Archive was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /archives/1
  def destroy
    @archive.destroy
    redirect_to archives_url, notice: 'Archive was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive
      @archive = Archive.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def archive_params
      params.require(:archive).permit(:id, :ecr_id, :stored_on, :user_id, :number_of_component, :updated_by, :orignal_value)
    end
end
