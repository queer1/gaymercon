class StripePayment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :donator
  
end
