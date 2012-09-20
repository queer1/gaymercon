MAILCHIMP_CONFIG = YAML.load(File.read(Rails.root.join("config", "mailchimp.yml")))[Rails.env]
MAILCHIMP = Hominid::API.new(MAILCHIMP_CONFIG['key'])