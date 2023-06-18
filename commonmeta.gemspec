# frozen_string_literal: true

require 'English'
require 'date'
require File.expand_path('lib/commonmeta/version', __dir__)

Gem::Specification.new do |s|
  s.authors       = 'Martin Fenner'
  s.email         = 'martin@front-matter.io'
  s.name          = 'commonmeta-ruby'
  s.homepage      = 'https://github.com/front-matter/commonmeta-ruby'
  s.summary       = 'Ruby client library for conversion of scholarly metadata'
  s.description   = 'Ruby gem and command-line utility for conversion of scholarly metadata from and to different metadata formats, including schema.org. Based on the bolognese gem, but using commonmeta as the intermediate format.'
  s.require_paths = ['lib']
  s.version       = Commonmeta::VERSION.dup
  s.extra_rdoc_files = ['README.md']
  s.license = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  # Declare dependencies here, rather than in the Gemfile
  s.add_dependency 'activesupport', '>= 4.2.5', '< 8.0'
  s.add_dependency 'addressable', '~> 2.8.1', '< 2.8.2'
  s.add_dependency 'base32-url', '>= 0.7.0', '< 1'
  s.add_dependency 'bibtex-ruby', '~> 6.0'
  s.add_dependency 'builder', '~> 3.2', '>= 3.2.4'
  s.add_dependency 'citeproc-ruby', '~> 2.0'
  s.add_dependency 'csl-styles', '~> 2.0'
  s.add_dependency 'edtf', '~> 3.0', '>= 3.0.4'
  s.add_dependency 'feedparser', '~> 2.2'
  s.add_dependency 'gender_detector', '~> 2.0'
  s.add_dependency 'http', '~> 5.1', '>= 5.1.1'
  s.add_dependency 'json-ld-preloaded', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'jsonlint', '~> 0.3.0'
  s.add_dependency 'json_schemer', '~> 1.0.1'
  s.add_dependency 'jwt', '~> 2.7', '>= 2.7.1'
  s.add_dependency 'loofah', '~> 2.19'
  s.add_dependency 'namae', '~> 1.0'
  s.add_dependency 'postrank-uri', '~> 1.1'
  s.add_dependency 'rdf-rdfxml', '~> 3.2'
  s.add_dependency 'rdf-turtle', '~> 3.2'
  s.add_dependency 'thor', '~> 1.2', '>= 1.2.2'
  s.add_development_dependency 'bundler', '~> 2.3', '>= 2.3.1'
  s.add_development_dependency 'code-scanning-rubocop', '~> 0.6.1'
  s.add_development_dependency 'hashdiff', '~> 1.0.1'
  s.add_development_dependency 'rack-test', '~> 2.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-xsd', '~> 0.1.0'
  s.add_development_dependency 'rubocop', '~> 1.36'
  s.add_development_dependency 'rubocop-performance', '~> 1.15'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.13'
  s.add_development_dependency 'simplecov', '0.22.0'
  s.add_development_dependency 'simplecov_json_formatter', '~> 0.1.4'
  s.add_development_dependency 'vcr', '~> 6.0', '>= 6.1.0'
  s.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'

  s.require_paths = ['lib']
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables = ['commonmeta']
  s.metadata['rubygems_mfa_required'] = 'true'
end
