$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "todays_plan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "todaysplan"
  s.version     = TodaysPlan::VERSION
  s.authors     = ["Curt Wilhelm"]
  s.email       = ["curt@9ksoftware.com"]
  s.homepage    = "https://github.com/9ksoftware/todaysplan-ruby"
  s.summary     = "A Ruby Library for TodaysPlan"
  s.description = "A Ruby Library for TodaysPlan"
  s.license     = "GPL"

  s.files = Dir["{lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  
  s.add_development_dependency 'rest-client'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rake'
    
  s.test_files = Dir["spec/**/*"]
end
