class GroupPost < ActiveRecord::Base
  
  include Locatable
  
  belongs_to :user
  belongs_to :group
  has_many :comments, :class_name => "GroupComment"
  
  after_create :grant_xp
  after_create :notify
  
  before_destroy :cleanup
  
  validates_presence_of :group_id
  validates_presence_of :user_id
  
  KINDS = ["discussion", "link", "image", "intro"]
  validates_inclusion_of :kind, :in => KINDS, :message => "is not valid."
  
  has_attached_file :image, :styles => { :medium => "570x580>", :thumb => "150x150>" }
  
  def self.kinds
    KINDS
  end
  
  def editor?(user)
    user.id == user_id || user.id == self.group.moderator_id || user.mod? || user.admin?
  end
  
  def url
    return "http://#{self.content}" unless self.content =~ /^https?:\/\/.*$/
    self.content
  end
  
  def unread?(user)
    self.comments.where("created_at > ?", user.last_sign_in_at).exists?
  end
  
  def replied?(user)
    self.comments.where(user_id: user.id).exists?
  end
  
  def last_reply
    self.comments.last
  end
  
  def get_nearby_users
    return [] unless self.kind == "event" && self.coords.present?
    self.nearby_users.where("id != ?", self.user_id).to_a.shuffle.take(5)
  end
  
  def grant_xp
    return unless
    u = self.user
    u.update_attributes(xp: u.xp + 10)
  end
  
  def notify
    self.group.users.each do |user|
      Notification::GroupNotification.find_or_create_by(:read => false, :user_id => user.id, :group_id => self.group.id).add_to_set(:post_ids, self.id) unless user.id == self.user_id
    end
    
    self.user.followers.each do |user|
      Notification::GroupNotification.find_or_create_by(:read => false, :user_id => user.id, :group_id => self.group.id).add_to_set(:post_ids, self.id) unless user.id == self.user_id
    end
  end
  
  def cleanup
    self.comments.destroy_all
    Notification::ThreadNotification.where(thread_id: self.id).destroy
  end
end
