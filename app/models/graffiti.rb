class Graffiti < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  validates_presence_of :user_id
  validates_presence_of :tag_id
  validates_presence_of :kind
end
