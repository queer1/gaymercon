class Notification::GroupNotification < Notification
  
  field :group_id, type: Integer
  field :post_ids, type: Array
  
  def self.clear(group, user)
    group = group.id if group.is_a?(Group)
    user = user.id if user.is_a?(User)
    self.where(group_id: group, user_id: user).set(:read, true)
  end
  
  def group
    Group.find_by_id(self.group_id)
  end
  
  def group=(new_group)
    gid = new_group.try(:id)
    gid ||= new_group if new_group.is_a?(Integer)
    self.group_id = gid
  end
  
  def message
    c = self.count
    noun = c > 1 ? "posts" : "post"
    "#{c} new #{noun} in #{self.group.name}"
  end
  
  def count
    self.post_ids.count
  end
  
  def link
    group_path(group_id)
  end
  
end