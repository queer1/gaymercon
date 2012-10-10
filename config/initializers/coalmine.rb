COALMINE = YAML.load(File.read(Rails.root.join("config", "coalmine.yml")))[Rails.env]
Coalmine.configure do |config|
  config.signature = COALMINE['signature']
  config.logger = Rails.logger
end