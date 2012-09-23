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
    
    Rails.logger.debug "PlaceFinder coords:\n#{info.inspect}"
    info = info.with_indifferent_access
    
    result_set = info['ResultSet']
    return unless result_set.present?
    
    results = result_set['Results']
    return unless results.present?
    
    result = results[0]
    return unless result.present?
    
    lat = result['latitude'].to_f
    lng = result['longitude'].to_f
    return unless lat.present? && lng.present?
    Rails.logger.debug "Found location [#{lat}, #{lng}]"
    [lat, lng]
  rescue Exception => e
    nil
  end
  
end