# frozen_string_literal: true

module Commonmeta
  module Readers
    module CodemetaReader
      def get_codemeta(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        id = normalize_id(id)
        url = github_as_codemeta_url(id)
        response = HTTP.get(url)
        return { 'string' => nil, 'state' => 'not_found' } unless response.status.success?

        { 'string' => response.body.to_s }
      end

      def read_codemeta(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        alternate_identifiers = Array.wrap(meta.fetch('identifier', nil)).map do |r|
          r = normalize_id(r) if r.is_a?(String)
          if r.is_a?(String) && URI(r) != 'doi.org'
            { 'alternateIdentifierType' => 'URL', 'alternateIdentifier' => r }
          elsif r.is_a?(Hash)
            { 'alternateIdentifierType' => get_identifier_type(r['propertyID']),
              'alternateIdentifier' => r['value'] }
          end
        end.compact.uniq

        id = normalize_id(options[:doi] || meta.fetch('@id', nil) || meta.fetch('identifier', nil))

        has_agents = meta.fetch('agents', nil)
        authors = has_agents.nil? ? meta.fetch('authors', nil) : has_agents
        contributors = get_authors(from_schema_org(Array.wrap(authors)))
        contributors += get_authors(from_schema_org(Array.wrap(meta.fetch('editor', nil))))
        
        # strip milliseconds from iso8601, as edtf library doesn't handle them
        date = {}
        if Date.edtf(strip_milliseconds(meta.fetch('datePublished', nil))).present?
          date['published'] = strip_milliseconds(meta.fetch('datePublished'))
        end
        if Date.edtf(strip_milliseconds(meta.fetch('dateCreated', nil))).present?
          date['created'] = strip_milliseconds(meta.fetch('dateCreated'))
        end
        if Date.edtf(strip_milliseconds(meta.fetch('dateModified', nil))).present?
          date['updated'] = strip_milliseconds(meta.fetch('dateModified'))
        end

        publisher = { 'name' => meta.fetch('publisher', nil) }.compact
        state = meta.present? || read_options.present? ? 'findable' : 'not_found'
        schema_org = meta.fetch('@type', nil)
        type = Commonmeta::Utils::SO_TO_CM_TRANSLATIONS.fetch(schema_org, 'Software')

        subjects = Array.wrap(meta.fetch('tags', nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        has_title = meta.fetch('title', nil)
        titles = if has_title.nil?
                   [{ 'title' => meta.fetch('name', nil) }]
                 else
                   [{ 'title' => has_title }]
                 end
        license = hsh_to_spdx('rightsIdentifier' => meta.fetch('licenseId'))

        { 'id' => id,
          'type' => type,
          'url' => normalize_id(meta.fetch('codeRepository', nil)),
          'titles' => titles,
          'contributors' => contributors,
          'publisher' => publisher,
          'date' => date,
          'descriptions' => if meta.fetch('description', nil).present?
                              [{ 'description' => sanitize(meta.fetch('description')),
                                 'descriptionType' => 'Abstract' }]
                            end,
          'license' => license,
          'version' => meta.fetch('version', nil),
          'alternate_identifiers' => alternate_identifiers,
          'subjects' => subjects,
          'state' => state }.compact.merge(read_options)
      end
    end
  end
end
