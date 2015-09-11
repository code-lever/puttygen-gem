# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puttygen/version'

Gem::Specification.new do |spec|
  spec.name          = 'puttygen'
  spec.version       = Puttygen::VERSION
  spec.authors       = ["Nick Veys"]
  spec.email         = ["nick@codelever.com"]

  spec.summary       = %q{Ruby gem wrapping the puttygen unix application.}
  spec.description   = %q{Convert or generate SSH keys using puttygen.}
  spec.homepage      = "http://github.com/code-lever/puttygen-gem"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'ci_reporter_rspec', '~> 1.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-checkstyle_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-gem-adapter'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'yard'

  spec.add_dependency 'ruby_expect', '~> 1.6'
end
