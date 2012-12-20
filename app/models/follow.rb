class Follow < ActiveRecord::Base
  
  # user IS FOLLOWING followed_user
  # user = the user DOING the following
  # followed_user = the user BEING FOLLOWED
  
  belongs_to :followed_user, class_name: "User"
  belongs_to :user
  
  validate :not_following_self
  validates_presence_of(:followed_user_id, :user_id)
  
  def not_following_self
    errors.add(:base, "You can't follow yourself! This is a family game.") if followed_user_id == user_id
  end
  
end
