# frozen_string_literal: true

module Briard
  module Readers
    module CffReader
      def get_cff(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        id = normalize_id(id)
        url = github_as_cff_url(id)
        conn = Faraday.new(url, request: { timeout: 5 }) do |f|
          f.request :gzip
          # f.request :json
          # f.response :json
        end
        response = conn.get(url)
        # body = JSON.parse(response.body)
        # Dates are parsed to date object, need to convert to iso8601 later
        string = Psych.safe_load(response.body, permitted_classes: [Date])
        { 'string' => string }
      end

      def read_cff(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        meta = string.is_a?(String) ? Psych.safe_load(string, permitted_classes: [Date]) : string

        identifiers = Array.wrap(meta.fetch('identifiers', nil)).map do |r|
          r = normalize_id(r) if r.is_a?(String)
          if r.is_a?(String) && URI(r).host != 'doi.org'
            { 'identifierType' => 'URL', 'identifier' => r }
          elsif r.is_a?(Hash)
            { 'identifierType' => get_identifier_type(r['propertyID']), 'identifier' => r['value'] }
          end
        end.compact.uniq

        id = normalize_id(options[:doi] || meta.fetch('doi',
                                                      nil) || Array.wrap(meta.fetch('identifiers', nil)).find do |i|
                                                                i['type'] == 'doi'
                                                              end.fetch('value', nil))
        url = normalize_id(meta.fetch('repository-code', nil))
        creators = cff_creators(Array.wrap(meta.fetch('authors', nil)))

        dates = []
        if meta.fetch('date-released', nil).present?
          dates << { 'date' => meta.fetch('date-released', nil).iso8601, 'dateType' => 'Issued' }
        end
        publication_year = meta.fetch('date-released').iso8601[0..3].to_i if meta.fetch('date-released',
                                                                                   nil).present?
        publisher = url.to_s.starts_with?('https://github.com') ? 'GitHub' : nil
        state = meta.present? || read_options.present? ? 'findable' : 'not_found'
        types = {
          'resourceTypeGeneral' => 'Software',
          'resourceType' => nil,
          'schemaOrg' => 'SoftwareSourceCode',
          'citeproc' => 'article-journal',
          'bibtex' => 'misc',
          'ris' => 'COMP'
        }.compact
        subjects = Array.wrap(meta.fetch('keywords', nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        titles = if meta.fetch('title', nil).present?
                   [{ 'title' => meta.fetch('title', nil) }]
                 else
                   []
                 end
        related_identifiers = Array.wrap(cff_references(meta.fetch('references', nil)))
        rights_list = if meta.fetch('license', nil).present?
                        [hsh_to_spdx('rightsIdentifier' => meta.fetch('license'))]
                      end

        { 'id' => id,
          'types' => types,
          'identifiers' => identifiers,
          'doi' => doi_from_url(id),
          'url' => url,
          'titles' => titles,
          'creators' => creators,
          'publisher' => publisher,
          'related_identifiers' => related_identifiers,
          'dates' => dates,
          'publication_year' => publication_year,
          'descriptions' => if meta.fetch('abstract', nil).present?
                              [{ 'description' => sanitize(meta.fetch('abstract')),
                                 'descriptionType' => 'Abstract' }]
                            end,
          'rights_list' => rights_list,
          'version_info' => meta.fetch('version', nil),
          'subjects' => subjects,
          'state' => state }.merge(read_options)
      end

      def cff_creators(creators)
        Array.wrap(creators).map do |a|
          name_identifiers = if normalize_orcid(parse_attributes(a['orcid'])).present?
                               [{
                                 'nameIdentifier' => normalize_orcid(parse_attributes(a['orcid'])), 'nameIdentifierScheme' => 'ORCID', 'schemeUri' => 'https://orcid.org'
                               }]
                             end
          if a['given-names'].present? || a['family-names'].present? || name_identifiers.present?
            given_name = parse_attributes(a['given-names'])
            family_name = parse_attributes(a['family-names'])
            affiliation = Array.wrap(a['affiliation']).map do |a|
              if a.is_a?(Hash)
                a
              elsif a.is_a?(Hash) && a.key?('__content__') && a['__content__'].strip.blank?
                nil
              elsif a.is_a?(Hash) && a.key?('__content__')
                { 'name' => a['__content__'] }
              elsif a.strip.blank?
                nil
              elsif a.is_a?(String)
                { 'name' => a }
              end
            end.compact

            { 'nameType' => 'Personal',
              'nameIdentifiers' => name_identifiers,
              'name' => [family_name, given_name].compact.join(', '),
              'givenName' => given_name,
              'familyName' => family_name,
              'affiliation' => affiliation.presence }.compact
          else
            { 'nameType' => 'Organizational',
              'name' => a['name'] || a['__content__'] }
          end
        end
      end

      def cff_references(references)
        Array.wrap(references).map do |r|
          identifier = Array.wrap(r['identifiers']).find { |i| i['type'] == 'doi' }

          next unless identifier.present?

          { 'relatedIdentifier' => normalize_id(parse_attributes(identifier['value'])),
            'relationType' => 'References',
            'relatedIdentifierType' => 'DOI' }.compact
        end.compact.unwrap
      end
    end
  end
end
