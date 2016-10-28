class Users::SessionsController < Devise::SessionsController
  include DeviseReturnToConcern
  prepend_before_filter :force_reset_session, only: :destroy

  def new
    @failed = params[:failed]
    @provider = params[:provider]
    if request.post? 
      user = User.find_by_email(params[:user][:email])
      if user.locked_at.present? and user.failed_attempts >=3
        flash[:alert] = "Your account is locked."
      end
    end
    return render 'failed' if @failed
    super
  end

  def force_reset_session
    reset_session
  end
end
