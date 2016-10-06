class Admin::UsersController < ApplicationController
  skip_authorization_check
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  def index
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @users = User.all
  end

  # GET /admin/users
  def deleted_user
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @users = User.only_deleted
  end

  # GET /admin/users/1
  def show
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
  end

  # GET /admin/users/new
  def new
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
    @workflows = WorkFlow.where(is_active: true, is_in_use: false)
  end

  # POST /admin/users
  def create
    is_user_with_same_email = User.unscoped.find_by_email(params[:user][:email])
    if !is_user_with_same_email.present?
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_url, notice: 'User was successfully created.'
      else
        render :new
      end
    else
      redirect_to new_admin_user_url, alert: "User already exit with email <strong>#{params[:user][:email]}</strong>"
    end  
  end

  # PATCH/PUT /admin/users/1
  def update
    if !params[:user][:password].present?
      params[:user].delete :password
    end
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end

  def activate_user
    User.restore(params[:id])
    redirect_to admin_users_url, notice: 'User was successfully activated.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end
