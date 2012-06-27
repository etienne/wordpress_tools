# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wordpress_tools/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Étienne Després"]
  gem.email         = ["etienne@molotov.ca"]
  gem.description   = %q{Command line tool to manage WordPress installations.}
  gem.summary       = %q{Manage WordPress installations.}
  gem.homepage      = "http://github.com/etienne/wordpress_tools"
  
  gem.add_dependency "thor"
  gem.add_dependency "php_serialize"
  
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fakeweb'
  
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "wordpress_tools"
  gem.require_paths = ["lib"]
  gem.version       = WordPressTools::VERSION
end
