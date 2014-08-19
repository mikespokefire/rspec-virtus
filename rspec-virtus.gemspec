# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-virtus/version'

Gem::Specification.new do |gem|
  gem.name          = "rspec-virtus"
  gem.version       = RSpec::Virtus::VERSION
  gem.authors       = ["Michael Smith"]
  gem.email         = ["mike@spokefire.co.uk"]
  gem.description   = %q{Simple RSpec matchers for Virtus objects}
  gem.summary       = %q{Simple RSpec matchers for Virtus objects}
  gem.homepage      = "https://github.com/mikespokefire/rspec-virtus"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rspec", ">= 3.0.0"
  gem.add_dependency "virtus", "~> 1.0.3"

  gem.add_development_dependency "rake", "~> 10.0.0"
end
