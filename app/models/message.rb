class Message < ActiveRecord::Base
  
  belongs_to :from_user, :class_name => "User"
  belongs_to :to_user, :class_name => "User"
  
  validates_presence_of :from_user
  validates_presence_of :to_user
  validates_presence_of :content
  
  validate :not_sent_to_self
  
  def read?
    self.read
  end
  
  def not_sent_to_self
    errors.add(:base, "You can't send a message to yourself, silly!") if from_user_id == to_user_id
  end
end
