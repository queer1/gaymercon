class ForumPost < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum_thread
  
  after_save :grant_xp
  
  def grant_xp
    return if self.class.where("created_at > ? and user_id = ?", Date.today, self.user_id).count > 10
    self.user.xp += 10
    self.user.save
  end
end
