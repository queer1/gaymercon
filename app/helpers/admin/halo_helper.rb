module Admin::HaloHelper
  def resource
    @user
  end
  
  def resource_name
    "user"
  end
  
  def devise_error_messages
    ""
  end
end
