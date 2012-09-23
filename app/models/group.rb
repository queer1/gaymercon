class Group < ActiveRecord::Base
  KINDS = ["game", "location", "interest"]
  belongs_to :moderator, :class_name => "User"
  has_many :posts, :class_name => "GroupPost"
  
  has_attached_file :header, :styles => { :large => "1000x381#" }
  
  validates_inclusion_of :kind, :in => KINDS, :message => "is not a valid group type."
  
  def self.kinds
    KINDS
  end
  
  def latest_posts(num = 10)
    posts.order("updated_at desc").limit(10).all
  end
end
