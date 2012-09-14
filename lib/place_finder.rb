class PlaceFinder
  include HTTParty
  base_uri 'http://where.yahooapis.com'
  debug_output $stderr
  
  def self.app_id
    return @app_id if @app_id.present?
    @config = YAML.load(File.read(File.join(Rails.root, 'config', 'yahoo.yml')))[Rails.env]
    @app_id = @config['app_id']
  end
  
  def self.coords(location)
    options = {:query => {:q => location,
               :appid => app_id,
               :flags => 'JC'}}
    results = self.get('/geocode', options)
    return nil unless results.code == 200
    info = results.parsed_response
    return nil unless info.is_a?(Hash)
    info = info.with_indifferent_access
    lat = info.dig('ResultSet', 'Results').try(:[], 0).try(:[], 'latitude').try(:to_f)
    lng = info.dig('ResultSet', 'Results').try(:[], 0).try(:[], 'longitude').try(:to_f)
    return nil unless lat.present? && lng.present?
    Rails.logger.debug "Found location [#{lat}, #{lng}]"
    [lat, lng]
  rescue Exception => e
    nil
  end
  
end