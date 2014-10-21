# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'botylicious/version'

Gem::Specification.new do |spec|
  spec.name          = "botylicious"
  spec.version       = Botylicious::VERSION
  spec.authors       = ["Parker Young"]
  spec.email         = ["parker@parkedonrails.com"]
  spec.description   = %q{The botylicious bot.}
  spec.summary       = %q{The botylicious bot is botylicious.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "pry"
  spec.add_runtime_dependency "cinch"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "pastie-api"
  spec.add_runtime_dependency "nokogiri"
end
