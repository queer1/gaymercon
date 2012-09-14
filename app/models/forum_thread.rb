class ForumThread < ActiveRecord::Base
  belongs_to :user
  has_many :forum_posts
  
  before_destroy :destroy_posts
  
  def destroy_posts
    self.posts.destroy_all
  end
  
  def replies_since(datetime)
    self.forum_posts.where("created_at > ?", datetime).count
  end
end
