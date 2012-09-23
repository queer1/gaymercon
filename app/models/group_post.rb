class GroupPost < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :group
  has_many :comments, :class_name => "GroupComment"
  
  KINDS = ["discussion", "link", "image", "intro", "event"]
  validates_inclusion_of :kind, :in => KINDS, :message => "is not valid."
  
  has_attached_file :header, :styles => { :medium => "570x580>", :thumb => "150x150>" }
  
  def self.kinds
    KINDS
  end
  
  def editor?(user)
    user.id == user_id || user.id == self.group.moderator_id || user.moderator? || user.admin?
  end
  
  def url
    return "http://#{self.content}" unless self.content =~ /^https?:\/\/.*$/
    self.content
  end
end
