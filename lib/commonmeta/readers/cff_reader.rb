# frozen_string_literal: true

module Commonmeta
  module Readers
    module CffReader
      def get_cff(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        id = normalize_id(id)
        url = github_as_cff_url(id)
        response = HTTP.get(url)
        
        { 'string' => response.body.to_s }
      end

      def read_cff(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        
        # Dates are parsed to date object, need to convert to iso8601 later
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

        date = {}
        if meta.fetch('date-released', nil).present?
          date['published'] = meta.fetch('date-released', nil).iso8601
        end
                            
        publisher = url.to_s.starts_with?('https://github.com') ? { 'name' => 'GitHub' } : nil
        state = meta.present? || read_options.present? ? 'findable' : 'not_found'
        
        type = 'Software'
        subjects = Array.wrap(meta.fetch('keywords', nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        titles = if meta.fetch('title', nil).present?
                   [{ 'title' => meta.fetch('title', nil) }]
                 else
                   []
                 end
        
        references = Array.wrap(meta.fetch("references", nil)).map { |r| get_cff_reference(r) }

        license = hsh_to_spdx('rightsIdentifier' => meta.fetch('license', nil))

        { 'id' => id,
          'type' => type,
          'identifiers' => identifiers,
          'url' => url,
          'titles' => titles,
          'creators' => creators,
          'publisher' => publisher,
          'references' => references,
          'date' => date,
          'descriptions' => if meta.fetch('abstract', nil).present?
                              [{ 'description' => sanitize(meta.fetch('abstract')),
                                 'descriptionType' => 'Abstract' }]
                            end,
          'license' => license,
          'version' => meta.fetch('version', nil),
          'subjects' => subjects,
          'state' => state }.compact.merge(read_options)
      end

      def cff_creators(creators)
        Array.wrap(creators).map do |a|
          id = normalize_orcid(parse_attributes(a['orcid']))
          if a['given-names'].present? || a['family-names'].present? || id.present?
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

            { 'type' => 'Person',
              'id' => id,
              'givenName' => given_name,
              'familyName' => family_name,
              'affiliation' => affiliation.presence }.compact
          else
            { 'type' => 'Organization',
              'name' => a['name'] || a['__content__'] }
          end
        end
      end

      def get_cff_reference(reference)
        return nil unless reference.present? || !reference.is_a?(Hash)
        
        doi = Array.wrap(reference['identifiers']).find { |i| i["type"] == "doi" }.to_h["value"]
        doi = normalize_doi(doi) if doi.present?
        url = reference.dig("url")
        date = {}
        date['published'] = reference.dig('date-released').iso8601 if reference.dig('date-released').present?
        
        {
          "key" => doi || url,
          "doi" => doi,
          "url" => url,
          "creator" => reference.dig("author"),
          "title" => reference.dig("article-title"),
          "publisher" => reference.dig("publisher"),
          "publicationYear" => date['published'] ? date['published'][0..3] : nil,
          "volume" => reference.dig("volume"),
          "issue" => reference.dig("issue"),
          "firstPage" => reference.dig("first-page"),
          "lastPage" => reference.dig("last-page"),
          "containerTitle" => reference.dig("journal-title"),
          "edition" => nil,
          "contributor" => nil,
          "unstructured" => doi.nil? ? reference.dig("unstructured") : nil,
        }.compact
      end
    end
  end
end
