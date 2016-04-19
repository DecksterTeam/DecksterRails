$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "deckster/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "deckster"
  s.version     = Deckster::VERSION
  s.authors     = ["Greg Hochard"]
  s.email       = ["hochardga@gmail.com"]
  s.homepage    = "http://decksterteam.github.io/DecksterRails/"
  s.summary     = "Deckster is an application kickstarter"
  s.description = "Deckster is an application kickstarter"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.10"
  s.add_dependency 'coffee-rails', '~> 4.0.0'
  s.add_dependency 'sass-rails', '~> 4.0.0'
  
  s.add_dependency 'autoprefixer-rails'
end
