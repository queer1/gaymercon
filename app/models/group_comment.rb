class GroupComment < ActiveRecord::Base
  belongs_to :group_post
  belongs_to :user
  
  validates_presence_of :group_post_id
  validates_presence_of :user_id
  
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
end
