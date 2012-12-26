class Nickname < ActiveRecord::Base
  belongs_to :user
  
  after_save :update_user
  
  NETWORKS = ["steam", "xbox", "psn", "3ds", "wii", "other"]
  
  def self.networks
    NETWORKS
  end
  
  def update_user
    self.user.solr_index
  end
end
