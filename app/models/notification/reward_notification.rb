class Notification::RewardNotification < Notification
  
  field :thread_id, type: Integer
  field :liker_ids, type: Array
  
  def self.clear(thread, user)
    thread = thread.id if thread.is_a?(GroupPost)
    user = user.id if user.is_a?(User)
    self.where(thread_id: thread, user_id: user).set(:read, true)
  end
  
  def thread
    GroupPost.find_by_id(self.thread_id)
  end
  
  def thread=(new_thread)
    gid = new_thread.try(:id)
    gid ||= new_thread if new_thread.is_a?(Integer)
    self.thread_id = gid
  end
  
  def likers
    User.where(id: liker_ids)
  end
  
  def message
    case self.count
    when 1
      like_user = User.find_by_id(self.liker_ids.first)
      return "#{like_user.try(:name) || "1 person"} rewarded your post in #{self.thread.try(:title)}"
    when 2..4
      users = User.where(id: liker_ids).all
      last = users.shift
      return "#{users.collect(&:name).join(', ')} and #{last.name} rewarded your post in #{self.thread.try(:title)}"
    when self.count > 4
      users = User.where(id: liker_ids).limit(3).all
      return "#{users.collect(&:name).join(', ')} and #{self.count - 3} other people rewarded your post in #{self.thread.try(:title)}"
    end
    "#{self.count} people rewarded your post in #{self.thread.try(:title)}"
  end
  
  def count
    self.liker_ids.count
  end
  
  def link
    self.thread.present? ? group_post_path(self.thread.group, thread_id) : "/"
  end
  
end