class Like < ActiveRecord::Base
  
  LIKEABLE = ['GroupPost', 'GroupComment']
  
  belongs_to :user
  belongs_to :group_post
  belongs_to :group_comment
  
  validates_presence_of(:klass)
  validates_presence_of(:user_id)
  validates_presence_of(:like_id)
  validates_inclusion_of(:klass, :in => LIKEABLE)
  
  after_create :grant_xp
  after_create :notify
  
  def obj
    self.klass.constantize.where(id: self.like_id).first
  end
  
  def grant_xp
    liked_user.update_attributes(xp: liked_user.xp + 15) if liked_user.present?
  end
  
  def notify
    Rails.logger.debug "klass: #{self.klass} like_id: #{self.like_id}"
    notif = nil
    case self.klass
    when 'GroupPost'
      notif = Notification::RewardNotification.find_or_create_by(:read => false, :user_id => liked_user.id, :thread_id => self.like_id)
    when 'GroupComment'
      notif = Notification::RewardNotification.find_or_create_by(:read => false, :user_id => liked_user.id, :thread_id => self.obj.post_id)
    end
    notif.add_to_set(:liker_ids, self.user_id)
  end
  
  def liked_user
    return nil unless obj.respond_to?(:user)
    return obj.user
  end
  
end
