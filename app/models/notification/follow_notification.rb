class Notification::FollowNotification < Notification
  
  field :follower_id, type: Integer
  
  def self.clear(follower, user)
    self.where(follower_id: follower.id, user_id: user.id).set(:read, true)
  end
  
  def follower
    User.where(id: self.follower_id).first
  end
  
  def follower=(new_follower)
    self.follower_id = new_follower.id
  end
  
  def message
    "#{self.follower.name} followed you!"
  end
  
  def count
    1
  end
  
  def link
    self.follower.present? ? user_path(self.follower) : "/"
  end
  
end