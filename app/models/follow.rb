class Follow < ActiveRecord::Base
  
  # user IS FOLLOWING followed_user
  # user = the user DOING the following
  # followed_user = the user BEING FOLLOWED
  
  after_create :notify
  after_create :grant_xp
  after_create :fb_publish
  after_destroy :fb_unpublish
  
  belongs_to :followed_user, class_name: "User"
  belongs_to :user
  
  validate :not_following_self
  validates_presence_of(:followed_user_id, :user_id)
  
  def not_following_self
    errors.add(:base, "You can't follow yourself! This is a family game.") if self.followed_user_id == self.user_id
  end
  
  def notify
    notif = Notification::FollowNotification.find_or_create_by(:read => false, :user_id => followed_user.id, :follower_id => user.id)
  end
  
  def grant_xp
    u = self.followed_user
    return unless u.present?
    u.update_attributes(xp: u.xp + 50)
  end
  
  def fb_publish
    return unless self.user.present? && self.user.fb_token.present?
    og = OpenGraph.new(self.user.fb_token)
    response = og.publish('follow', self.followed_user )
    self.update_attributes(og_id: response["id"]) if response.present?
  end
  
  def fb_unpublish
    return unless self.user.present? && self.user.fb_token.present? && self.og_id.present?
    og = OpenGraph.new(self.user.fb_token)
    og.unpublish(self.og_id)
  end
  
end
