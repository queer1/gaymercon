module DeviseRedirector
  
  def after_sign_up_path_for(resource)
    devise_redirect(resource)
  end
  
  
  def after_sign_in_path_for(resource)
    devise_redirect(resource)
  end
  
  def devise_redirect(user)
    devise_return = session.delete(:user_return_to)
    return_to = session.delete(:return_to)
    Rails.logger.debug "Redirector: #{devise_return} | #{return_to} | #{request.env['omniauth.origin']} | #{user.just_created}"
    return request.env['omniauth.origin'] if request.env['omniauth.origin']
    return params[:return_to] if params[:return_to].present?
    return devise_return if devise_return.present?
    return return_to if return_to.present?
    return join_path if user.just_created
    home_path
  end
end
