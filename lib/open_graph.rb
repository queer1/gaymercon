require 'timeout'
class OpenGraph
  
  include Rails.application.routes.url_helpers
  
  def initialize(new_token)
    @fbgraph = FbGraph::User.me(new_token)
    @token = new_token
  end
  
  def publish(action, obj)
    Rails.logger.info "[OpenGraph] Publishing #{action} #{obj} #{@token}"
    kind = self.class.determine_kind(obj)
    opts = {access_token: @token, kind => self.class.determine_url(obj)}
    Timeout.timeout(2) do |t|
      me = FbGraph::User.me(@token)
      action = me.og_action!("gaymerx:#{kind}", :custom_object => self.class.determine_url(obj))
      Rails.logger.info "[OpenGraph] " + action.inspect
      return action
    end
  rescue Exception => e
    Rails.logger.error("[OpenGraph] " + e.inspect)
    Coalmine.notify(e) if Rails.env == "production"
    return nil
  end
  
  def update(og_id, opts = {})
    Rails.logger.info "OpenGraph: Updating #{og_id} #{opts.inspect}"
    kind = self.class.determine_kind(obj)
    opts = {access_token: @token, kind => self.class.determine_url(obj)}
    Timeout.timeout(2) do |t|
      me = FbGraph::User.me(@token)
      action = me.og_action!("gaymerx:#{kind}", :custom_object => self.class.determine_url(obj))
      Rails.logger.info "[OpenGraph] " + action.inspect
      return action
    end
  rescue Exception => e
    Rails.logger.error(e)
    Coalmine.notify(e) if Rails.env == "production"
    return nil
  end
  
  def unpublish(og_id)
    Rails.logger.info "OpenGraph: Deleting #{og_id}"
    kind = self.class.determine_kind(obj)
    opts = {access_token: @token, kind => self.class.determine_url(obj)}
    Timeout.timeout(2) do |t|
      action = FbGraph::OpenGraph::Action.new(og_id, access_token: @token)
      action.destroy
      Rails.logger.info "[OpenGraph] " + action.inspect
      return action
    end
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
      return 'unknown'
    end
  end
  
  def self.determine_url(obj)
    return obj.og_url if obj.respond_to?(:og_url)
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