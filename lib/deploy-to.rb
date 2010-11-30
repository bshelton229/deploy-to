require 'yaml'
require 'date'

# Load deploy-to
Dir[File.expand_path('../deploy-to/*.rb',__FILE__)].each {|f| require f }
