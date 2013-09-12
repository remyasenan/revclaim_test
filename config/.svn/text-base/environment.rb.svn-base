# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Revclaim::Application.initialize!


if Rack::Utils.respond_to?("key_space_limit=")
  Rack::Utils.key_space_limit = 262144
end
