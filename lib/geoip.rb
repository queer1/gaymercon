class Geoip
  
  EARTH_RADIUS = 6371.0
  KM_IN_MI = 0.621371192
  
  class << self
    def lookup(ip)
      @@instance ||= GeoIP::City.new(File.join(Rails.root, 'lib', 'assets', 'GeoLiteCity.dat'))
      @@instance.look_up(ip)
    end
  end
end