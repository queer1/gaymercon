module Likeable
  def likes
    Like.where(klass: self.class.name, like_id: self.id, revoked: false)
  end
  
  def all_likes
    Like.where(klass: self.class.name, like_id: self.id)
  end
  
  def like(user)
    return unless user.present?
    user_like = Like.where(user_id: user.id, klass: self.class.name, like_id: self.id).first_or_create
    user_like.update_attributes(revoked: false)
    return user_like
  end
  
  def unlike(user)
    return unless user.present?
    user_like = Like.where(user_id: user.id, klass: self.class.name, like_id: self.id).first
    user_like.update_attributes(revoked: true)
    return user_like
  end
end