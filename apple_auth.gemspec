# frozen_string_literal: true

require_relative 'lib/apple_auth/base/version'

Gem::Specification.new do |spec|
  spec.name          = 'apple_auth'
  spec.version       = AppleAuth::Base::VERSION
  spec.authors       = ['Timothy Peraza, Antonieta Alvarez, Martín Morón']
  spec.email         = ['timothy@rootstrap.com, antonieta.alvarez@rootstrap.com, martin.jaime@rootstrap.com']

  spec.summary       = 'Integration with Apple Sign In and Devise for backend. Validate and Verify user token.'
  spec.homepage      = 'https://github.com/rootstrap/apple_auth'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/rootstrap/apple_auth'
  spec.metadata['changelog_uri'] = 'https://github.com/rootstrap/apple_auth'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Production dependencies
  spec.add_dependency 'jwt', '~> 2.2'
  spec.add_dependency 'oauth2', '~> 2.0'

  # Development dependencies
  spec.add_development_dependency 'generator_spec', '~> 0.9.4'
  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'railties', '~> 6.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek', '~> 5.6'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'parser', '~> 2.7.1.1'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
