# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'digestifier'
  spec.version       = '0.0.1'
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
end
