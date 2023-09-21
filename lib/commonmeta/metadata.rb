# frozen_string_literal: truefiles

require_relative 'metadata_utils'

module Commonmeta
  class Metadata
    include Commonmeta::MetadataUtils

    attr_accessor :string, :from, :sandbox, :meta, :regenerate, :issue, :show_errors, :depositor,
                  :email, :registrant
    attr_reader :doc, :page_start, :page_end
    attr_writer :id, :provider_id, :client_id, :doi, :alternate_identifiers, :contributors,
                :titles, :publisher, :license, :date, :volume, :url, :version, :subjects, :descriptions, :language, :sizes, :formats, :schema_version, :meta, :container, :provider, :format, :funding_references, :state, :geo_locations, :type, :additional_type, :files, :references, :related_identifiers, :related_items, :style, :locale

    def initialize(options = {})
      options.symbolize_keys!

      id = normalize_id(options[:input], options)
      ra = nil

      if id.present?
        @from = options[:from] || find_from_format(id: id)

        # mEDRA, KISTI, JaLC and OP DOIs are found in the Crossref index
        case @from
        when 'medra'
          ra = 'mEDRA'
        when 'kisti'
          ra = 'KISTI'
        when 'jalc'
          ra = 'JaLC'
        when 'op'
          ra = 'OP'
        end

        # generate name for method to call dynamically
        hsh = @from.present? ? send("get_#{@from}", id: id, **options) : {}
        string = hsh.fetch('string', nil)
      elsif options[:input].present? && File.exist?(options[:input])
        filename = File.basename(options[:input])
        ext = File.extname(options[:input])
        if %w[.bib .ris .xml .json .cff].include?(ext)
          hsh = {
            'url' => options[:url],
            'state' => options[:state],
            'provider_id' => options[:provider_id],
            'client_id' => options[:client_id],
            'files' => options[:files]
          }
          string = File.read(options[:input])
          @from = options[:from] || find_from_format(string: string, ext: ext)
        else
          warn "File type #{ext} not supported"
          exit 1
        end
      else
        hsh = {
          'url' => options[:url],
          'state' => options[:state],
          'provider_id' => options[:provider_id],
          'client_id' => options[:client_id],
          'files' => options[:files],
          'contributors' => options[:contributors],
          'titles' => options[:titles],
          'publisher' => options[:publisher]
        }
        string = options[:input]
        @from = options[:from] || find_from_format(string: string)
      end

      # make sure input is encoded as utf8
      if string.present? && string.is_a?(String)
        dup_string = string.dup.force_encoding('UTF-8').encode!
      end
      @string = dup_string

      # input options for citation formatting
      @style = options[:style]
      @locale = options[:locale]

      @sandbox = options[:sandbox]

      # options that come from the datacite database
      @url = hsh.to_h['url'].presence || options[:url].presence
      @state = hsh.to_h['state'].presence
      @provider_id = hsh.to_h['provider_id'].presence
      @client_id = hsh.to_h['client_id'].presence
      @files = hsh.to_h['files'].presence

      # options that come from the cli, needed
      # for crossref doi registration
      @depositor = options[:depositor]
      @email = options[:email]
      @registrant = options[:registrant]

      # set attributes directly
      read_options = options.slice(
        :contributors,
        :titles,
        :type,
        :additional_type,
        :container,
        :publisher,
        :funding_references,
        :date,
        :descriptions,
        :rights_list,
        :version,
        :subjects,
        :language,
        :geo_locations,
        :references,
        :alternate_identifiers,
        :related_identifiers,
        :related_items,
        :formats,
        :sizes
      ).compact

      @regenerate = options[:regenerate] || read_options.present?
      # generate name for method to call dynamically
      opts = { string: @string, sandbox: options[:sandbox], doi: options[:doi], id: id,
               ra: ra }.merge(read_options)
      @meta = @from.present? ? send("read_#{@from}", **opts) : {}
    end

    def id
      @id ||= meta.fetch('id', nil)
    end

    def doi
      @doi ||= meta.fetch('doi', nil)
    end

    def provider_id
      @provider_id ||= meta.fetch('provider_id', nil)
    end

    def client_id
      @client_id ||= meta.fetch('client_id', nil)
    end

    def exists?
      (@state || meta.fetch('state', nil)) != 'not_found'
    end

    def valid?
      exists? && errors.nil?
    end

    # Catch errors in the reader
    # Then validate against JSON schema for Commonmeta
    def errors
      meta.fetch('errors', nil) || json_schema_errors
    end

    def descriptions
      @descriptions ||= meta.fetch('descriptions', nil)
    end

    def license
      @license ||= meta.fetch('license', nil)
    end

    def subjects
      @subjects ||= meta.fetch('subjects', nil)
    end

    def language
      @language ||= meta.fetch('language', nil)
    end

    def sizes
      @sizes ||= meta.fetch('sizes', nil)
    end

    def formats
      @formats ||= meta.fetch('formats', nil)
    end

    def schema_version
      @schema_version ||= meta.fetch('schema_version', nil)
    end

    def funding_references
      @funding_references ||= meta.fetch('funding_references', nil)
    end

    def references
      @references ||= meta.fetch('references', nil)
    end

    def related_identifiers
      @related_identifiers ||= meta.fetch('related_identifiers', nil)
    end

    def related_items
      @related_items ||= meta.fetch('related_items', nil)
    end

    def url
      @url ||= meta.fetch('url', nil)
    end

    def version
      @version ||= meta.fetch('version', nil)
    end

    def container
      @container ||= meta.fetch('container', nil)
    end

    def geo_locations
      @geo_locations ||= meta.fetch('geo_locations', nil)
    end

    def date
      @date ||= meta.fetch('date', nil)
    end

    def publisher
      @publisher ||= meta.fetch('publisher', nil)
    end

    def alternate_identifiers
      @alternate_identifiers ||= meta.fetch('alternate_identifiers', nil)
    end

    def files
      @files ||= meta.fetch('files', nil)
    end

    def provider
      @provider ||= meta.fetch('provider', nil)
    end

    def state
      @state ||= meta.fetch('state', nil)
    end

    def type
      @type ||= meta.fetch('type', nil)
    end

    def additional_type
      @additional_type ||= meta.fetch('additional_type', nil)
    end

    def titles
      @titles ||= meta.fetch('titles', nil)
    end

    def contributors
      @contributors ||= meta.fetch('contributors', nil)
    end
  end
end
