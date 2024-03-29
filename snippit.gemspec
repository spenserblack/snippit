# frozen_string_literal: true

require_relative 'lib/snippit/version'

Gem::Specification.new do |spec|
  spec.name                     = 'snippit'
  spec.version                  = Snippit::VERSION
  spec.authors                  = ['Spenser Black']

  spec.summary                 = 'Manage your personal code snippets'
  spec.description             = 'Define, store, and output your code snippets'

  spec.homepage                = 'https://github.com/spenserblack/snippit'
  spec.license                 = 'MIT'

  spec.required_ruby_version   = Gem::Requirement.new('>= 2.7.0')

  spec.files                   = Dir['lib/**/*'] + Dir['exe/*'] + Dir['[A-Z]*']

  spec.bindir                  = 'exe'
  spec.executables             = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths           = ['lib']

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/releases",
    'documentation_uri' => "https://rubydoc.info/gems/#{spec.name}",
    'source_code_uri' => spec.homepage,
    'github_repo' => "ssh://github.com/spenserblack/#{spec.name}",
    'rubygems_mfa_required' => 'true'
  }
end
