class IaController < ApplicationController
  before_action :set_ium, only: [:show, :edit, :update, :destroy]

  # GET /ia
  def index
    @ia = Ium.all
  end

  # GET /ia/1
  def show
  end

  # GET /ia/new
  def new
    @ium = Ium.new
  end

  # GET /ia/1/edit
  def edit
  end

  # POST /ia
  def create
    @ium = Ium.new(ium_params)

    if @ium.save
      redirect_to @ium, notice: 'Ium was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ia/1
  def update
    if @ium.update(ium_params)
      redirect_to @ium, notice: 'Ium was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ia/1
  def destroy
    @ium.destroy
    redirect_to ia_url, notice: 'Ium was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ium
      @ium = Ium.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ium_params
      params.require(:ium).permit(:name, :translation, :horw, :inbox_date, :sent_date, :received_date, :project_id)
    end
end
