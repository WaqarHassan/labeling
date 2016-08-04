class EcrsController < ApplicationController
  before_action :set_ecr, only: [:show, :edit, :update, :destroy]
   skip_authorization_check 
  # GET /ecrs
  def index
    @ecrs = Ecr.all
  end

  # GET /ecrs/1
  def show
  end

  # GET /ecrs/new
  def new
    @ia = Ia.all
    comp_attribute = AttributeList.find_by_label('Component Type')
    @components = comp_attribute.attribute_list_values

    @show_projects = 'dropdown'
      @ecr = Ecr.new
      respond_to do |format|
        format.html
        format.js
      end
  end

  # GET /ecrs/1/edit
  def edit
  end

  # POST /ecrs
  def create
    @ecr = Ecr.new(ecr_params)

    if @ecr.save
      redirect_to root_path, notice: 'Ecr was successfully created.'
    else
      render :new
    end
  end

  
   # GET /ecrs/new
  def add_nested_ecr
    @ia = Ia.all
    comp_attribute = AttributeList.find_by_label('Component Type')
    @components = comp_attribute.attribute_list_values

    @show_projects = 'dropdown'
      @ecr = Ecr.find(params[:ecr_id])
      respond_to do |format|
        format.html
        format.js
      end
  end


  # PATCH/PUT /ecrs/1
  def update
    if @ecr.update(ecr_params)
      redirect_to root_path, notice: 'Ecr was successfully updated.'
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
      params.require(:ecr).permit(:id, :name, :status, :note, :ia_id,:comp_count,:comp_type)
    end
end
