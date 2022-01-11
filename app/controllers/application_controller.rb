class ApplicationController < ActionController::Base
  helper_method :admin_user?
  
  def admin_user?
    user_signed_in? && current_user.admin?
  end

  def require_admin_user
    if !user_signed_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to user_session_path
    elsif !current_user.admin?
      flash[:alert] = "You must be an admin to perform that action"
      redirect_to root_path      
    end
  end

end
