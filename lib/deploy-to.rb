require 'optparse'
require 'yaml'
require 'date'

#Load all of our libraries
Dir[File.expand_path('../deploy-to/*.rb',__FILE__)].each {|f| require f}
