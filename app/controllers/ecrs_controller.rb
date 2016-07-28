class EcrsController < ApplicationController
  before_action :set_ecr, only: [:show, :edit, :update, :destroy]
   skip_authorization_check only: :create
  # GET /ecrs
  def index
    @ecrs = Ecr.all
  end

  # GET /ecrs/1
  def show
  end

  # GET /ecrs/new
  def new
    @ecr = Ecr.new
  end

  # GET /ecrs/1/edit
  def edit
  end

  # POST /ecrs
  def create
    @ecr = Ecr.new(ecr_params)

    if @ecr.save
      redirect_to main_index_path, notice: 'Ecr was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ecrs/1
  def update
    if @ecr.update(ecr_params)
      redirect_to @ecr, notice: 'Ecr was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ecrs/1
  def destroy
    @ecr.destroy
    redirect_to ecrs_url, notice: 'Ecr was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ecr
      @ecr = Ecr.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ecr_params
      params.require(:ecr).permit(:id, :name, :user_id, :status, :note, :station_id, :status_start, :rework_of)
    end
end
