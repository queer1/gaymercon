class Users::SessionsController < Devise::SessionsController
  
  layout 'no_controls'
  before_filter do @section_name = (params[:action] == "new") ? "Create a Profile" : "Log In" end
  
  def destroy
    session.delete(:return_to)
    session.delete(:user_return_to)
    super
  end
  
end
