lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'deploy-to'

Gem::Specification.new do |s|
  s.name = 'deploy-to'
  s.version = DeployTo::VERSION
  s.authors = ["Bryan Shelton"]
  s.email = 'bryan@sheltonopensolutions.com'
  s.summary = 'Rsync deployment wrapper'
  s.homepage = 'http://github.com/bshelton229/deploy-to'
  s.description = 'DeployTo Project'

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.executables = ['deploy-to']
  s.files = Dir['Readme.md','lib/**/*','bin/*']
end
