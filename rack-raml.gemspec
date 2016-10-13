# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/raml/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-raml"
  spec.version       = Rack::Raml::VERSION
  spec.authors       = ["Ray Zane"]
  spec.email         = ["ray@promptworks.com"]

  spec.summary       = %q{A mock RAML server for Rack-based applications.}
  spec.description   = %q{A mock RAML server for Rack-based applications.}
  spec.homepage      = "https://github.com/rzane/rack-raml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack'
  spec.add_dependency 'raml_ruby'
  spec.add_dependency 'uri_template'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
