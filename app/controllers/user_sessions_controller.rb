class UserSessionsController < ApplicationController
  skip_before_filter :redirect_to_welcome
  def new
    @user_session = UserSession.new
    @user = User.new
  end

  def create
    @user_session = UserSession.new(user_params)
    if @user_session.save
      cookies[:hadean_uid] = @user_session.record.access_token
      session[:authenticated_at] = Time.now
      cookies[:insecure] = false
      ## if there is a cart make sure the user_id is correct
      set_user_to_cart_items(@user_session)
      merge_carts
      flash[:notice] = I18n.t('login_successful')
      @user = User.new
      if @user_session.record.admin?
        redirect_back_or_default admin_users_url
      else
        redirect_back_or_default root_url
      end
    else
      flash[:session_alert] =  I18n.t('login_failure')
      redirect_to login_url
    end
  end

  def destroy
    current_user_session.destroy
    reset_session
    cookies.delete(:hadean_uid)
    redirect_to login_url, :notice => I18n.t('logout_successful')
  end

  private

  def user_params
    params.require(:user_session).permit(:password, :password_confirmation, :first_name, :last_name, :email)
  end

end
