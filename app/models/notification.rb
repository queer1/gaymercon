class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers
  
  field :user_id, type: Integer
  field :read, type: Boolean, default: false
  
  index :user_id => -1
  
  def self.unread_count(user)
    self.where(user_id: user.id, read: false).count
  end
  
  def user
    User.find_by_id(self.user_id)
  end
  
  def user=(new_user)
    uid = new_user.try(:id)
    uid ||= new_user if new_user.is_a?(Integer)
    self.user_id = uid
  end
  
  #############################################
  # Methods to be overridden in subclasses
  #############################################
  def count
    1
  end
  
  def link
    root_path
  end
  
end
