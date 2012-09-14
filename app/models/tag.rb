class Tag < ActiveRecord::Base
  
  validates_presence_of :name, allow_blank: false
  validates_uniqueness_of :name
  
end
