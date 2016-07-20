class ReworkInfosController < ApplicationController
  before_action :set_rework_info, only: [:show, :edit, :update, :destroy]

  # GET /rework_infos
  def index
    @rework_infos = ReworkInfo.all
  end

  # GET /rework_infos/1
  def show
  end

  # GET /rework_infos/new
  def new
    @rework_info = ReworkInfo.new
  end

  # GET /rework_infos/1/edit
  def edit
  end

  # POST /rework_infos
  def create
    @rework_info = ReworkInfo.new(rework_info_params)

    if @rework_info.save
      redirect_to @rework_info, notice: 'Rework info was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rework_infos/1
  def update
    if @rework_info.update(rework_info_params)
      redirect_to @rework_info, notice: 'Rework info was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rework_infos/1
  def destroy
    @rework_info.destroy
    redirect_to rework_infos_url, notice: 'Rework info was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rework_info
      @rework_info = ReworkInfo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rework_info_params
      params.require(:rework_info).permit(:collab_name, :time_stamp, :user_id, :station_id, :reason, :comp_number, :type, :ecr_id)
    end
end
