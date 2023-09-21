# frozen_string_literal: true

module Commonmeta
  module Readers
    module DataciteReader
      def get_datacite(id: nil, **options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        api_url = datacite_api_url(id, options)
        response = HTTP.get(api_url)
        return { 'string' => nil, 'state' => 'not_found' } unless response.status.success?

        body = JSON.parse(response.body)
        client = Array.wrap(body.fetch('included', nil)).find do |m|
          m['type'] == 'clients'
        end
        client_id = client.to_h.fetch('id', nil)
        provider_id = Array.wrap(client.to_h.fetch('relationships', nil)).find do |m|
          m['provider'].present?
        end.to_h.dig('provider', 'data', 'id')

        { 'string' => response.body.to_s,
          'provider_id' => provider_id,
          'client_id' => client_id }
      end

      def read_datacite(string: nil, **_options)
        errors = jsonlint(string)
        return { 'errors' => errors } if errors.present?

        read_options = ActiveSupport::HashWithIndifferentAccess.new(_options.except(:doi, :id, :url,
                                                                                    :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        # optionally strip out the message wrapper from API
        meta = meta.dig('data', 'attributes') if meta.dig('data').present?

        meta.transform_keys!(&:underscore)

        id = normalize_doi(meta.fetch('doi', nil))

        resource_type_general = meta.dig('types', 'resourceTypeGeneral')
        resource_type = meta.dig('types', 'resourceType')
        # if resource_type is one of the new resource_type_general types introduced in schema 4.3, use it
        type = Commonmeta::Utils::DC_TO_CM_TRANSLATIONS.fetch(resource_type, nil) ||
               Commonmeta::Utils::DC_TO_CM_TRANSLATIONS.fetch(resource_type_general, 'Other')

        alternate_identifiers = Array.wrap(meta.fetch('alternate_identifiers', nil)).map do |i|
          i.transform_keys! { |k| k.camelize(:lower) }
        end
        url = meta.fetch('url', nil)
        titles = Array.wrap(meta.fetch('titles', nil)).map do |title|
          title.compact
        end
        contributors = get_authors(from_datacite(meta.fetch('creators', nil)))
        contributors += get_authors(from_datacite(meta.fetch('contributors', nil)))
        publisher = { 'name' => meta.fetch('publisher', nil) }

        container = meta.fetch('container', nil)
        funding_references = meta.fetch('funding_references', nil)

        date = {}
        date['created'] =
          get_iso8601_date(meta.dig('created')) || get_date(meta.dig('dates'), 'Created')
        date['published'] =
          get_iso8601_date(meta.dig('published')) || get_date(meta.dig('dates'),
                                                              'Issued') || get_iso8601_date(meta.dig('publication_year'))
        date['registered'] = get_iso8601_date(meta.dig('registered'))
        date['updated'] =
          get_iso8601_date(meta.dig('updated')) || get_date(meta.dig('dates'), 'Updated')

        descriptions = Array.wrap(meta.fetch('descriptions', nil)).map do |description|
          description.compact
        end
        license = Array.wrap(meta.fetch('rights_list', nil)).find do |r|
          r['rightsUri'].present?
        end
        license = hsh_to_spdx('rightsURI' => license['rightsUri']) if license.present?
        version = meta.fetch('version', nil)
        subjects = meta.fetch('subjects', nil)
        language = meta.fetch('language', nil)
        geo_locations = meta.fetch('geo_locations', nil)
        references = (Array.wrap(meta.fetch('related_identifiers',
                                            nil)) + Array.wrap(meta.fetch('related_items',
                                                                          nil))).select do |r|
                       %w[References Cites IsSupplementedBy].include?(r['relationType'])
                     end.map do |reference|
          get_datacite_reference(reference)
        end
        files = Array.wrap(meta.fetch("content_url", nil)).map { |file| { "url" => file } }    
        formats = meta.fetch('formats', nil)
        sizes = meta.fetch('sizes', nil)
        schema_version = meta.fetch('schema_version', nil) || 'http://datacite.org/schema/kernel-4'
        state = id.present? || read_options.present? ? 'findable' : 'not_found'

        { 'id' => id,
          'type' => type,
          'additional_type' => resource_type == type ? nil : resource_type,
          'url' => url,
          'titles' => titles,
          'contributors' => contributors,
          'container' => container,
          'publisher' => publisher,
          'provider' => 'DataCite',
          'alternate_identifiers' => alternate_identifiers.presence,
          'references' => references,
          'funding_references' => funding_references,
          'files' => files.presence,
          'date' => date.compact,
          'descriptions' => descriptions,
          'license' => license,
          'version' => version,
          'subjects' => subjects,
          'language' => language,
          'geo_locations' => geo_locations,
          'formats' => formats,
          'sizes' => sizes,
          'state' => state }.compact # .merge(read_options)
      end

      def format_contributor(contributor)
        type = contributor.fetch('nameType', nil)

        { 'name' => type == 'Person' ? nil : contributor.fetch('name', nil),
          'type' => type,
          'givenName' => contributor.fetch('givenName', nil),
          'familyName' => contributor.fetch('familyName', nil),
          'nameIdentifiers' => contributor.fetch('nameIdentifiers', nil).presence,
          'affiliations' => contributor.fetch('affiliations', nil).presence,
          'contributorType' => contributor.fetch('contributorType', nil) }.compact
      end

      def get_datacite_reference(reference)
        return nil unless reference.present? || !reference.is_a?(Hash)

        key = reference['relatedIdentifier']
        doi = nil
        url = nil

        case reference['relatedIdentifierType']
        when 'DOI'
          doi = normalize_doi(reference['relatedIdentifier'])
        when 'URL'
          url = reference['relatedIdentifier']
        else
          url = reference['relatedIdentifier']
        end

        {
          'key' => key,
          'doi' => doi,
          'url' => url,
          'contributor' => reference.dig('author'),
          'title' => reference.dig('article-title'),
          'publisher' => reference.dig('publisher'),
          'publicationYear' => reference.dig('year'),
          'volume' => reference.dig('volume'),
          'issue' => reference.dig('issue'),
          'firstPage' => reference.dig('first-page'),
          'lastPage' => reference.dig('last-page'),
          'containerTitle' => reference.dig('journal-title'),
          'edition' => nil,
          'unstructured' => doi.nil? ? reference.dig('unstructured') : nil
        }.compact
      end
    end
  end
end
