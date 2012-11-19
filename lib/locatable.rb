module Locatable
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def location
    @location ||= Location.find_or_create_by(item_id: self.id, item_class: self.class.name.underscore)
    @location
  end
  
  def place=(new_place)
    prev_place = self.location.place
    return if prev_place == new_place
    coords = PlaceFinder.coords(new_place)
    location.place = new_place
    location.coords = coords
    location.save
  end
  
  def place
    self.location.place
  end
  
  def coords=(new_coords)
    raise ArgumentError.new("Coordinates must by a [lat, lng] array!") unless new_coords.is_a?(Array) && new_coords.count == 2
    return true if location.coords == new_coords
    location.coords = new_coords
    location.save
  end
  
  def coords
    return nil if location.coords == [199.9, 199.9]
    location.coords
  end
  
  def distance_from(point_arr)
    Geocalc.distance_between(self.coords, point_arr)
  end
  
  def nearby(max_miles_away = 50)
    location.nearby(max_miles_away, self.class.name.underscore)
  end
  
  def method_missing(method, *args, &block)
    return location.send(:nearby, args[0], $1.downcase.singularize) if method.to_s =~ /nearby_(\w+)/
    super(method, *args, &block)
  end
  
  module ClassMethods
    def nearby(coords, max_miles_away = 50)
      Rails.logger.info "Finding nearby #{self.name.underscore} : #{coords.inspect}"
      Location.nearby(coords, max_miles_away, self.name.underscore)
    end
    
    def method_missing(method, *args, &block)
      return Location.nearby(args[0], args[1], $1.downcase.singularize) if method.to_s =~ /nearby_(\w+)/
      super(method, *args, &block)
    end
  end
  
end