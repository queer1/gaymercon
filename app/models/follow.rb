class Follow < ActiveRecord::Base
  
  # user IS FOLLOWING followed_user
  # user = the user DOING the following
  # followed_user = the user BEING FOLLOWED
  
  belongs_to :followed_user, class_name: "User"
  belongs_to :user
  
end
