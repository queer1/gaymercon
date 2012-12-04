class Panelist < ActiveRecord::Base
  belongs_to :panel
  
  validates_presence_of :name, :email, :phone, :address_1, :city, :province, :country, :age
  
end
