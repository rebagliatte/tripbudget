# Load the rails application
require File.expand_path('../application', __FILE__)

# Load app keys
settings = File.join(Rails.root.to_s, 'config', 'settings.rb')
load(settings) if File.exists?(settings)

# Initialize the rails application
Tripbudget::Application.initialize!
