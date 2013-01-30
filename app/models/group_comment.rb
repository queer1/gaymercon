class GroupComment < ActiveRecord::Base
  belongs_to :group_post
  belongs_to :user
  
  validates_presence_of :group_post_id
  validates_presence_of :user_id
  
  after_create :grant_xp
  after_create :notify
  after_create :reindex_thread
  
  before_destroy :delete_notifications
  
  def post
    self.group_post
  end
  
  def post_id
    self.group_post_id
  end
  
  def post=(new_post)
    self.group_post = new_post
  end
  
  def group
    self.group_post.group
  end
  
  def group_id
    self.group_post.group_id
  end
  
  def editor?(other_user)
    return true if other_user.try(:mod?)
    return false unless other_user.id.present?
    return false unless self.user_id.present?
    return true if other_user.id == self.group.try(:moderator_id)
    return true if self.user_id == other_user.id
    return false
  end
  
  def grant_xp
    return unless
    u = self.user
    u.update_attributes(xp: u.xp + 10)
  end
  
  def notify
    group = self.group
    group.users.each do |user|
      next if group.private? && !group.visible_to?(user)
      next if user.id == self.user_id
      notif = Notification::ThreadNotification.find_or_create_by(:read => false, :user_id => user.id, :thread_id => self.group_post.id, :reason => "member")
      notif.add_to_set(:comment_ids, self.id)
      notif.update_attributes!(reason: "member")
    end
    
    self.user.followers.each do |user|
      next if group.private? && !group.visible_to?(user)
      next if user.id == self.user_id
      notif = Notification::ThreadNotification.find_or_create_by(:read => false, :user_id => user.id, :thread_id => self.group_post.id, :reason => "follow")
      notif.add_to_set(:comment_ids, self.id)
      notif.update_attributes!(reason: "follow")
    end
  end
  
  def reindex_thread
    self.post.index
  end
  
  def delete_notifications
    Notification.where(thread_id: self.group_post.id).destroy
  end
end
