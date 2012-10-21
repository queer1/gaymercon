class GroupComment < ActiveRecord::Base
  belongs_to :group_post
  belongs_to :user
  
  validates_presence_of :group_post_id
  validates_presence_of :user_id
  
  after_create :grant_xp
  after_create :notify
  
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
  
  def editor?(user)
    return true if user.try(:mod?)
    return false unless user.id.present?
    return false unless self.user_id.present?
    user_id == self.group.try(:moderator_id) || self.user_id == user.id
  end
  
  def grant_xp
    return unless
    u = self.user
    u.update_attributes(xp: u.xp + 10)
  end
  
  def notify
    self.group.users.each do |user|
      Notification::ThreadNotification.find_or_create_by(:read => false, :user_id => user.id, :thread_id => self.group_post.id).add_to_set(:comment_ids, self.id) unless user.id == self.user_id
    end
  end
end
