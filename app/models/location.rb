class Location
  include Mongoid::Document
    
  field :coords, :type => Array, :default => lambda{ [199.9, 199.9] }
  index({ coords: "2d" }, { min: -200, max: 200 })
  
  field :place, type: String
  field :item_id, type: Integer
  field :item_class, type: String
  
  def set?
    !(self.coords.nil? || self.coords == [199.9, 199.9])
  end
  
  def self.nearby(coords, max_miles_away = 50, item_class = "user")
    # convert to lat/lng coord distance, as per http://www.mongodb.org/display/DOCS/Geospatial+Indexing
    max_miles_away = 50 unless max_miles_away.present?
    item_ids = self.where(:coords => {"$near" => coords , '$maxDistance' => max_miles_away.fdiv(69)}, :item_class => item_class).to_a
    item_ids.collect!(&:item_id)
    klass = item_class.classify.constantize
    klass.where("#{item_class.pluralize}.id IN (?)", item_ids)
  end
  
  def nearby(max_miles_away = 50, item_class = "user")
    return [] if !self.set?
    self.class.nearby(self.coords, max_miles_away, item_class)
  end
  
  def self.method_missing(method, *args, &block)
    return self.nearby(args[0], args[1], $1.downcase.singularize) if method.to_s =~ /nearby_(\w+)/
    super(method, *args, &block)
  end
  
  def method_missing(method, *args, &block)
    return self.nearby(args[0], $1.downcase.singularize) if method.to_s =~ /nearby_(\w+)/
    super(method, *args, &block)
  end
  
end