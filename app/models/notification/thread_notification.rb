class Notification::ThreadNotification < Notification
  
  field :thread_id, type: Integer
  field :comment_ids, type: Array
  
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
  
  def message
    c = self.count
    noun = c > 1 ? "replies" : "reply"
    "#{c} new #{noun} to \"#{self.thread.title}\""
  end
  
  def count
    self.comment_ids.count
  end
  
  def link
    group_post_path(self.thread.group_id, thread_id)
  end
  
end