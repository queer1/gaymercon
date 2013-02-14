class OpenGraph
  
  include Rails.application.routes.url_helpers
  include HTTParty
  base_uri 'https://graph.facebook.com'
  debug_output $stderr
  
  def initialize(new_token)
    @token = new_token
  end
  
  def publish(action, obj)
    Rails.logger.debug "OpenGraph: Publishing #{action} #{obj} #{@token}"
    kind = self.class.determine_kind(obj)
    opts = {access_token: @token, kind => self.class.determine_url(obj)}
    response = self.class.post("/me/gaymerx:#{kind.to_s.underscore}", opts)
    Rails.logger.debug response.parsed_response
    return response.parsed_response
  rescue Exception => e
    Rails.logger.error(e)
    Coalmine.notify(e) if Rails.env == "production"
    return nil
  end
  
  def update(og_id, opts = {})
    Rails.logger.debug "OpenGraph: Updating #{og_id} #{opts.inspect}"
    opts = {access_token: @token}.merge(opts)
    response = self.class.post("/#{og_id}", opts)
    Rails.logger.debug response.parsed_response
    return !!response.parsed_response
  rescue Exception => e
    Rails.logger.error(e)
    Coalmine.notify(e) if Rails.env == "production"
    return nil
  end
  
  def unpublish(og_id)
    Rails.logger.debug "OpenGraph: Deleting #{og_id}"
    opts = {access_token: @token}
    response = self.class.post("/#{og_id}", opts)
    Rails.logger.debug response.parsed_response
    return !!response.parsed_response
  rescue Exception => e
    Rails.logger.error(e)
    Coalmine.notify(e) if Rails.env == "production"
    return nil
  end
  
  def self.determine_kind(obj)
    case obj.class
    when User
      return :profile
    when Group
      return :group
    when GroupPost
      return :post
    when GroupComment
      return :comment
    when Panel
      return :panel
    else
      return ''
    end
  end
  
  def self.determine_url(obj)
    host = "http://www.gaymerconnect.com"
    url = nil
    case obj.class
    when User
      return user_url(obj, host: host)
    when Group
      return group_url(obj, host: host)
    when GroupPost
      return group_post_url(obj.group, obj, host: hose)
    when GroupComment
      return group_post_comment_url(obj.group, obj.post, obj, host: hose)
    when Panel
      return panel_url(obj, host: host)
    else
      return host
    end
  end
  
end