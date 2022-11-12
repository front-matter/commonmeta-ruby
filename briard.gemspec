# frozen_string_literal: true

require 'English'
require 'date'
require File.expand_path('lib/briard/version', __dir__)

Gem::Specification.new do |s|
  s.authors       = 'Martin Fenner'
  s.email         = 'martin@front-matter.io'
  s.name          = 'briard'
  s.homepage      = 'https://github.com/front-matter/briard'
  s.summary       = 'Ruby client library for conversion of DOI Metadata'
  s.description   = 'Ruby gem and command-line utility for conversion of DOI metadata from and to different metadata formats, including schema.org. Fork of version 1.19.12 of the bolognese gem.'
  s.require_paths = ['lib']
  s.version       = Briard::VERSION
  s.extra_rdoc_files = ['README.md']
  s.license = 'MIT'
  s.required_ruby_version = '~> 2.3'

  # Declare dependencies here, rather than in the Gemfile
  s.add_dependency 'activesupport', '>= 4.2.5'
  s.add_dependency 'base32-url', '>= 0.5.0', '< 1'
  s.add_dependency 'benchmark_methods', '~> 0.7'
  s.add_dependency 'bibtex-ruby', '>= 5.1.0'
  s.add_dependency 'builder', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'citeproc-ruby', '~> 1.1', '>= 1.1.12'
  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'concurrent-ruby', '~> 1.1', '>= 1.1.5'
  s.add_dependency 'csl-styles', '~> 1.0', '>= 1.0.1.10'
  s.add_dependency 'dotenv', '~> 2.1', '>= 2.1.1'
  s.add_dependency 'edtf', '~> 3.0', '>= 3.0.4'
  s.add_dependency 'faraday', '~> 2.6.0'
  s.add_dependency 'faraday-multipart', '~> 1.0.4'
  s.add_dependency 'gender_detector', '~> 0.1.2'
  s.add_dependency 'iso8601', '~> 0.9.1'
  s.add_dependency 'json-ld-preloaded', '~> 3.1', '>= 3.1.3'
  s.add_dependency 'jsonlint', '~> 0.3.0'
  s.add_dependency 'loofah', '~> 2.0', '>= 2.0.3'
  s.add_dependency 'maremma', '>= 4.9.7', '< 5'
  s.add_dependency 'namae', '~> 1.0'
  s.add_dependency 'nokogiri', '~> 1.13.1'
  s.add_dependency 'oj', '~> 3.10'
  s.add_dependency 'oj_mimic_json', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'postrank-uri', '~> 1.0', '>= 1.0.18'
  s.add_dependency 'public_suffix', '2.0.5'
  s.add_dependency 'rdf-rdfxml', '~> 3.1'
  s.add_dependency 'rdf-turtle', '~> 3.1'
  s.add_dependency 'thor', '>= 1.1.0'
  s.add_development_dependency 'bundler', '>= 1.0'
  s.add_development_dependency 'code-scanning-rubocop', '~> 0.6.1'
  s.add_development_dependency 'hashdiff', ['>= 1.0.0.beta1', '< 2.0.0']
  s.add_development_dependency 'rack-test', '~> 2.0'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-xsd', '~> 0.1.0'
  s.add_development_dependency 'rubocop', '~> 1.36'
  s.add_development_dependency 'rubocop-performance', '~> 1.15'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.13'
  s.add_development_dependency 'simplecov', '0.21.2'
  s.add_development_dependency 'simplecov_json_formatter', '~> 0.1.2'
  s.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  s.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'

  s.require_paths = ['lib']
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables = ['briard']
  s.metadata['rubygems_mfa_required'] = 'true'
end
