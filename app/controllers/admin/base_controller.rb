class Admin::BaseController < ApplicationController
  layout 'admin'
  skip_before_filter :redirect_to_welcome

  before_filter :verify_admin

  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end


  private

  def add_to_recent_user(user)
    session[:recent_users] ||= []
    if session[:recent_users].any?{|email, id| id == user.id }
      session[:recent_users].delete_if {|email, id| id == user.id}
    elsif session[:recent_users].size > 12
      session[:recent_users].pop
    end
    session[:recent_users].unshift( [user.email, user.id] )
  end

  def ssl_required?
    ssl_supported?
  end

  def verify_admin
    redirect_to root_url if !current_user || !current_user.admin?
  end

end
