class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :banned?
  include DeviseRedirector
  
  private
  def admin_only!
    redirect_to(:root, error: "You don't have permission to do that.") and return false unless current_user.present? && current_user.admin?
  end
  
  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:notice] = nil
      flash[:error] = "Your account has been suspended."
      root_path
    end
  end
  
  def beta
    if Rails.env == "production" && !current_user
      flash[:notice] = "Sorry, we're still in closed beta"
      redirect_to root_path and return
    end
  end
end
