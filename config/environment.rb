# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gc2::Application.initialize!
require Rails.root.join("lib", "core_ext")
DATE_FORMAT = "%b %-d, %Y"
TIME_FORMAT = DATE_FORMAT + " | %l:%M%P"