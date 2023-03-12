# frozen_string_literal: true

module Briard
  module Readers
    module CodemetaReader
      def get_codemeta(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        id = normalize_id(id)
        url = github_as_codemeta_url(id)
        conn = Faraday.new(url, request: { timeout: 5 }) do |f|
          f.request :gzip
          f.request :json
          # f.response :json
        end
        response = conn.get(url)
        body = JSON.parse(response.body)
        string = body.fetch('data', nil)

        { 'string' => string }
      end

      def read_codemeta(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { 'errors' => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        identifiers = Array.wrap(meta.fetch('identifier', nil)).map do |r|
          r = normalize_id(r) if r.is_a?(String)
          if r.is_a?(String) && URI(r) != 'doi.org'
            { 'identifierType' => 'URL', 'identifier' => r }
          elsif r.is_a?(Hash)
            { 'identifierType' => get_identifier_type(r['propertyID']), 'identifier' => r['value'] }
          end
        end.compact.uniq

        id = normalize_id(options[:doi] || meta.fetch('@id', nil) || meta.fetch('identifier', nil))

        has_agents = meta.fetch('agents', nil)
        authors =  has_agents.nil? ? meta.fetch('authors', nil) : has_agents
        creators = get_authors(from_schema_org_creators(Array.wrap(authors)))

        contributors = get_authors(from_schema_org_contributors(Array.wrap(meta.fetch('editor',
                                                                                      nil))))
        dates = []
        dates << { 'date' => meta.fetch('datePublished'), 'dateType' => 'Issued' } if meta.fetch(
          'datePublished', nil
        ).present?
        dates << { 'date' => meta.fetch('dateCreated'), 'dateType' => 'Created' } if meta.fetch(
          'dateCreated', nil
        ).present?
        dates << { 'date' => meta.fetch('dateModified'), 'dateType' => 'Updated' } if meta.fetch(
          'dateModified', nil
        ).present?
        publication_year = meta.fetch('datePublished')[0..3].to_i if meta.fetch('datePublished',
                                                                           nil).present?
        publisher = meta.fetch('publisher', nil)
        state = meta.present? || read_options.present? ? 'findable' : 'not_found'
        schema_org = meta.fetch('@type', nil)
        types = {
          'resourceTypeGeneral' => Briard::Utils::SO_TO_DC_TRANSLATIONS[schema_org],
          'resourceType' => meta.fetch('additionalType', nil),
          'schemaOrg' => schema_org,
          'citeproc' => Briard::Utils::SO_TO_CP_TRANSLATIONS[schema_org] || 'article-journal',
          'bibtex' => Briard::Utils::SO_TO_BIB_TRANSLATIONS[schema_org] || 'misc',
          'ris' => Briard::Utils::SO_TO_RIS_TRANSLATIONS[schema_org] || 'GEN'
        }.compact
        subjects = Array.wrap(meta.fetch('tags', nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        has_title = meta.fetch('title', nil)
        titles =  if has_title.nil?
                    [{ 'title' => meta.fetch('name', nil) }]
                  else
                    [{ 'title' => has_title }]
                  end
        rights_list = if meta.fetch('licenseId', nil).present?
                        [hsh_to_spdx('rightsIdentifier' => meta.fetch('licenseId'))]
                      end

        { 'id' => id,
          'types' => types,
          'identifiers' => identifiers,
          'doi' => doi_from_url(id),
          'url' => normalize_id(meta.fetch('codeRepository', nil)),
          'titles' => titles,
          'creators' => creators,
          'contributors' => contributors,
          'publisher' => publisher,
          # {}"is_part_of" => is_part_of,
          'dates' => dates,
          'publication_year' => publication_year,
          'descriptions' => if meta.fetch('description', nil).present?
                              [{ 'description' => sanitize(meta.fetch('description')),
                                 'descriptionType' => 'Abstract' }]
                            end,
          'rights_list' => rights_list,
          'version_info' => meta.fetch('version', nil),
          'subjects' => subjects,
          'state' => state }.merge(read_options)
      end

      # def related_identifiers(relation_type)
      #   normalize_ids(ids: metadata.fetch(relation_type, nil), relation_type: relation_type)
      # end
      #
      # def same_as
      #   related_identifiers("isIdenticalTo")
      # end
      #
      # def is_part_of
      #   related_identifiers("isPartOf")
      # end
      #
      # def has_part
      #   related_identifiers("hasPart")
      # end
      #
      # def citation
      #   related_identifiers("citation")
      # end
    end
  end
end
