class Users::PasswordsController < Devise::PasswordsController
  
  layout 'no_controls'
  before_filter do @section_name = params[:action] == "new" ? "Forgot your Passowrd?" : "Reset Password" end
  
end
