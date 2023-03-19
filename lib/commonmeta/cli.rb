# frozen_string_literal: true

require "thor"

require_relative 'doi_utils'
require_relative 'utils'

module Commonmeta
  class CLI < Thor
    include Commonmeta::DoiUtils
    include Commonmeta::Utils

    def self.exit_on_failure?
      true
    end

    # from http://stackoverflow.com/questions/22809972/adding-a-version-option-to-a-ruby-thor-cli
    map %w[--version -v] => :__print_version

    desc "--version, -v", "print the version"

    def __print_version
      puts Commonmeta::VERSION
    end

    desc "", "convert metadata"
    method_option :from, aliases: "-f"
    method_option :to, aliases: "-t", default: "schema_org"
    method_option :regenerate, type: :boolean, force: false
    method_option :style, aliases: "-s", default: "apa"
    method_option :locale, aliases: "-l", default: "en-US"
    method_option :show_errors, type: :boolean, force: false
    method_option :depositor
    method_option :email
    method_option :registrant

    def convert(input)
      metadata = Metadata.new(input: input,
                              from: options[:from],
                              regenerate: options[:regenerate],
                              style: options[:style],
                              locale: options[:locale],
                              show_errors: options[:show_errors],
                              depositor: options[:depositor],
                              email: options[:email],
                              registrant: options[:registrant])
      to = options[:to] || "schema_org"

      if options[:show_errors] && !metadata.valid?
        warn metadata.errors
      else
        puts metadata.send(to)
      end
    end

    desc "", "encode"

    def encode(prefix)
      puts encode_doi(prefix)
    end

    desc "", "decode"

    def decode(doi)
      puts decode_doi(doi)
    end

    default_task :convert
  end
end
