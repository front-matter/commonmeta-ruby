# frozen_string_literal: true

require "thor"

require_relative "doi_utils"
require_relative "utils"

module Commonmeta
  class CLI < Thor
    include Commonmeta::DoiUtils
    include Commonmeta::Utils
    include Commonmeta::Readers::JsonFeedReader

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
    method_option :doi
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
                              doi: options[:doi],
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

    desc "", "encode_id"

    def encode_id
      puts encode_container_id
    end

    desc "", "encode_by_blog"

    def encode_by_blog(blog_id)
      prefix = get_doi_prefix_by_blog_id(blog_id)
      puts encode_doi(prefix)
    end

    desc "", "encode_by_uuid"

    def encode_by_uuid(uuid)
      prefix = get_doi_prefix_by_json_feed_item_uuid(uuid)
      puts encode_doi(prefix)
    end

    desc "", "decode"

    def decode(doi)
      puts decode_doi(doi)
    end

    desc "", "decode_id"

    def decode_id(id)
      puts decode_container_id(id)
    end

    desc "", "json_feed_unregistered"

    def json_feed_unregistered
      puts get_json_feed_unregistered
    end

    desc "", "json_feed_not_indexed"

    def json_feed_not_indexed(date_indexed)
      puts get_json_feed_not_indexed(date_indexed)
    end

    desc "", "json_feed_by_blog"

    def json_feed_by_blog(id)
      puts get_json_feed_by_blog(id)
    end

    default_task :convert
  end
end
