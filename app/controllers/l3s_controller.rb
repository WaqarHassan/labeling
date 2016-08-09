class L3sController < ApplicationController
  before_action :set_l3, only: [:show, :edit, :update, :destroy]
   skip_authorization_check 
  # GET /l3s
  def index
    @l3s = L3.all
  end

  # GET /l3s/1
  def show
  end

  # GET /l3s/new
  def new
    
    @action = 'ADD'
    @btn_action = 'SAVE'
    if params.has_key?(:l2_id)
      @show_projects = 'readonly'
      @ia = L2.find(params[:l2_id])
    else 
      @show_projects = 'dropdown'
      @ia = L2.all 
    end 
    comp_attribute = AttributeList.find_by_label('Component Type')
    @components = comp_attribute.attribute_list_values
    
    @l3 = L3.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /l3s/1/edit
  def edit
     @ia = @l3.l2
      #@ia = Ia.all
    comp_attribute = AttributeList.find_by_label('Component Type')
    @components = comp_attribute.attribute_list_values
    @action = 'UPDATE'
    @btn_action = 'UPDATE'
    
    @show_projects = 'dropdowncxd'
    #  @ia_find = Ia.find(params[:id])
      respond_to do |format|
        format.html
        format.js
      end



  end

  # POST /l3s
  def create
    @l3 = L3.new(l3_params)

    if @l3.save
      redirect_to root_path, notice: 'L3 was successfully created.'
    else
      render :new
    end
  end

  
   # GET /l3s/new
  def add_nested_ecr
    @ia = Ia.all
    comp_attribute = AttributeList.find_by_label('Component Type')
    @components = comp_attribute.attribute_list_values

    @l3 = L3.new
    @show_projects = 'dropdown'
      @ia_find = Ia.find(params[:l3_id])
      respond_to do |format|
        format.html
        format.js
      end
  end


  # PATCH/PUT /l3s/1
  def update
    if @l3.update(l3_params)
      redirect_to root_path, notice: 'L3 was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /l3s/1
  def destroy
    @l3.destroy
    redirect_to l3s_url, notice: 'L3 was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_l3
      @l3 = L3.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def l3_params
      params.require(:l3).permit(:id, :name, :status, :note, :l2_id,:comp_count,:comp_type)
    end
end
