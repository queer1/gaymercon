class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = "Signed in via Facebook!"
      sign_in @user
      redirect_to edit_user_registration_path
    else
      flash[:alert] = "Oops, there was a problem: #{@user.all_errors}"
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = "Signed in via Twitter!"
      sign_in @user
      redirect_to edit_user_registration_path
    else
      flash[:alert] = "Oops, there was a problem: #{@user.all_errors}"
      session["devise.twitter_data"] = request.env["omniauth.auth.credentials"]
      redirect_to new_user_registration_url
    end
  end
  
  def disconnect
    redirect_to login_path, alert: "You must be logged in to do that." and return unless current_user.present?
    redirect_to edit_user_registration_path(tab: "settings"), alert: "You must pick a network to disconnect!" and return unless ["facebook", "twitter"].include?(params[:id])
    
    case params[:id] 
    when "facebook"
      redirect_to edit_user_registration_path(tab: "settings"), alert: "Doesn't seem like you have a Facebook account connected." and return unless current_user.fb_token.present?
      current_user.fb_token = nil
      current_user.fb_expires = nil
      current_user.save
    when "twitter"
      redirect_to edit_user_registration_path(tab: "settings"), alert: "Doesn't seem like you have a Twitter account connected." and return unless current_user.tw_token.present?
      current_user.tw_token = nil
      current_user.tw_expires = nil
      current_user.save
    end
    
    redirect_to edit_user_registration_path(tab: "settings"), notice: "#{params[:id].to_s.capitalize} account disconnected."
  end
end