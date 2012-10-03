class GroupPost < ActiveRecord::Base
  
  include Locatable
  
  belongs_to :user
  belongs_to :group
  has_many :comments, :class_name => "GroupComment"
  
  KINDS = ["discussion", "link", "image", "intro", "event"]
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
  
  def replied?(user)
    self.comments.where(user_id: user.id).exists?
  end
  
  def get_nearby_users
    return [] unless self.kind == "event" && self.coords.present?
    self.nearby_users.where("id != ?", self.user_id).to_a.shuffle.take(5)
  end
end
