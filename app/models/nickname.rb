class Nickname < ActiveRecord::Base
  belongs_to :user
  
  NETWORKS = ["steam", "xbox", "psn", "3ds", "wii", "other"]
  
  def self.networks
    NETWORKS
  end
end
