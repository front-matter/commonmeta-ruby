# frozen_string_literal: true

require 'dotenv/load'
require 'active_support/all'
require 'nokogiri'
require 'maremma'
require 'postrank-uri'
require 'bibtex'
require 'colorize'
require 'loofah'
require 'json/ld'
require 'rdf/turtle'
require 'rdf/rdfxml'
require 'logger'
require 'iso8601'
require 'jsonlint'
require 'benchmark_methods'
require 'gender_detector'
require 'citeproc/ruby'
require 'citeproc'
require 'csl/styles'
require 'edtf'
require 'base32/url'

require "briard/version"
require "briard/metadata"
require "briard/cli"
require "briard/string"
require "briard/array"
require "briard/whitelist_scrubber"

ENV['USER_AGENT'] ||= "Mozilla/5.0 (compatible; Maremma/#{Maremma::VERSION}; mailto:info@front-matter.io)"
