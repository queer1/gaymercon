STRIPE = YAML.load(File.read(Rails.root.join("config", "stripe.yml")))[Rails.env]
Stripe.api_key = STRIPE['secret']