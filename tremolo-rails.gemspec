# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tremolo-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "tremolo-rails"
  spec.version       = Tremolo::Rails::VERSION
  spec.authors       = ["Tony Pitale"]
  spec.email         = ["tpitale@gmail.com"]

  spec.summary       = %q{Rails integration with Tremolo for seamless Influxdb measurement.}
  spec.description   = %q{Rails integration with Tremolo for seamless Influxdb measurement.}
  spec.homepage      = "https://github.com/tpitale/tremolo-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "bourne"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rails", ">= 3.0"

  spec.add_dependency "tremolo", ">= 0.2.2"
end
