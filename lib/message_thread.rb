class MessageThread
  
  attr_accessor :current_user, :user, :messages
  
  def initialize(new_current_user, other_user)
    @current_user = new_current_user
    @user = other_user
    @messages = Message.where("(to_user_id = ? and from_user_id = ?) or (to_user_id = ? and from_user_id = ?)", current_user.id, user.id, user.id, current_user.id).order("created_at desc")
  end
  
  def self.all_for_user(user)
    other_user_ids = Message.select("to_user_id, from_user_id, IF(to_user_id = '#{user.id}', from_user_id, to_user_id) as other_user_id").where('to_user_id = ? or from_user_id = ?', user.id, user.id).group("other_user_id").order("created_at asc").collect(&:other_user_id)
    other_users = other_user_ids.collect{|uid| User.find_by_id(uid)}.compact
    return [] unless other_users.present?
    other_users.collect {|other| self.new(user, other) }
  end
  
  def last_message
    messages.first
  end
  
  def read?
    messages.first.created_at <= current_user.last_sign_in_at
  end
  
  def unread?
    !read?
  end
end