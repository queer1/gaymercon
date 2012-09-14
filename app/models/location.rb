class Location
  include Mongoid::Document
  
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  
  field :coords, :type => Array, :default => lambda{ [199.9, 199.9] }
  index({ coords: "2d" }, { min: -200, max: 200 })
  
  field :user_id, type: Integer
  
  def self.nearby_users(coords, max_miles_away = 50)
    # convert to lat/lng coord distance, as per http://www.mongodb.org/display/DOCS/Geospatial+Indexing
    user_ids = self.where(:coords => {"$near" => coords , '$maxDistance' => max_miles_away.fdiv(69)})
    User.where("id IN (?)", user_ids)
  end
end