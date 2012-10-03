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
end