# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'digestifier'
  spec.version       = '0.1.0'
  spec.authors       = ['Pat Allan']
  spec.email         = ['pat@freelancing-gods.com']
  spec.summary       = 'Digests as a Rails Engine'
  spec.description   = 'A Rails engine that lets you define and customise digest emails'
  spec.homepage      = 'https://github.com/inspire9/digestifier'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.2'

  spec.add_development_dependency 'combustion',  '~> 0.5.1'
  spec.add_development_dependency 'rspec-rails', '~> 3.3.3'
  spec.add_development_dependency 'sqlite3',     '~> 1.3.10'
end
