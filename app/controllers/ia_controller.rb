class IaController < ApplicationController
  before_action :set_ia, only: [:show, :edit, :update, :destroy]
  skip_authorization_check 
  # GET /ia
  def index
    @ia = Ia.all
  end

  # GET /ia/1
  def show
  end

  # GET /ia/new
  def new
    @project = current_user.projects.all 

    @ia = Ia.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /ia/1/edit
  def edit
  end

  # POST /ia
  def create
    @ia = Ia.new(ia_params)

    if @ia.save
      redirect_to root_path, notice: 'Ia was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ia/1
  def update
    if @ia.update(ia_params)
      redirect_to @ia, notice: 'Ia was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ia/1
  def destroy
    @ia.destroy
    redirect_to ia_url, notice: 'Ia was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ia
      @ia = Ia.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ia_params
      params.require(:ia).permit(:name, :translation, :horw, :inbox_date, :sent_date, :received_date, :project_id)
    end
end
