lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'deploy-to/version'

Gem::Specification.new do |s|
  s.name = 'deploy-to'
  s.version = DeployTo::VERSION
  s.authors = ["Bryan Shelton", "Perry Kibler"]
  s.email = ["bryan@sheltonopensolutions.com"]
  s.summary = %q{Rsync deployment application}
  s.homepage = %q{http://github.com/bshelton229/deploy-to}
  s.description = %q{Allows you to create a deploy-to.yml file in your poject that determines different ignores and remote locations to deploy your project via rsync.}

  s.required_ruby_version     = ">= 1.8.6"
  s.required_rubygems_version = ">= 1.3.6"

  s.executables = ["d2"]
  
  s.files = Dir['Readme.md', 'LICENSE', 'lib/**/*', 'bin/*']
end
