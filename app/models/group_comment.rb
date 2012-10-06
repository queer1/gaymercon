class GroupComment < ActiveRecord::Base
  belongs_to :group_post
  belongs_to :user
  
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
    self.user.id == user_id || user.id == self.group.moderator_id || user.mod?
  end
end
