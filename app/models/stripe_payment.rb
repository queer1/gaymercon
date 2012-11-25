class StripePayment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :donator
  belongs_to :badge
  
end
