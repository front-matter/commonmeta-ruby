# frozen_string_literal: true

require 'dotenv/load'
require 'active_support/all'
require 'nokogiri'
ActiveSupport::XmlMini.backend='Nokogiri'
require 'http'
require 'multi_json'
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

require 'commonmeta/version'
require 'commonmeta/metadata'
require 'commonmeta/cli'
require 'commonmeta/string'
require 'commonmeta/array'
require 'commonmeta/whitelist_scrubber'
require 'commonmeta/xml_converter'

ENV['USER_AGENT'] ||= "Mozilla/5.0 (compatible; mailto:info@front-matter.io)"
