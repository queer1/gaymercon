class GroupAlias < ActiveRecord::Base
  belongs_to :group
  acts_as_url :name, sync_url: true
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
