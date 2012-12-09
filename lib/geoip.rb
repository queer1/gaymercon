class Geoip
  
  EARTH_RADIUS = 6371.0
  KM_IN_MI = 0.621371192
  
  class << self
    def lookup(ip)
      @@instance ||= GeoIP::City.new(File.join(Rails.root, 'lib', 'assets', 'GeoLiteCity.dat'))
      @@instance.look_up(ip)
    end
    
    def get_coords(ip)
      geoip = self.lookup(id)
      return nil unless geoip.present? && geoip['latitude'].present? && geoip.longitude.present?
      [geoip['latitude'], geoip['longitdue']]
    end
  end
end