# frozen_string_literal: true

module Commonmeta
  module Readers
    module NpmReader
      def get_npm(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        url = normalize_id(id)
        response = HTTP.get(url)
        return { 'string' => nil, 'state' => 'not_found' } unless response.status.success?

        { 'string' => response.body.to_s }
      end

      def read_npm(hsh: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { 'errors' => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        type = 'Software'

        contributors = get_authors(Array.wrap(meta.fetch('author', nil)))
        license = hsh_to_spdx('rightsIdentifier' => meta.fetch('license', nil))

        # container = if meta.fetch("container-title", nil).present?
        #   first_page = meta.fetch("page", nil).present? ? meta.fetch("page").split("-").map(&:strip)[0] : nil
        #   last_page = meta.fetch("page", nil).present? ? meta.fetch("page").split("-").map(&:strip)[1] : nil

        #   { "type" => "Periodical",
        #     "title" => meta.fetch("container-title", nil),
        #     "identifier" => meta.fetch("ISSN", nil),
        #     "identifierType" => meta.fetch("ISSN", nil).present? ? "ISSN" : nil,
        #     "volume" => meta.fetch("volume", nil),
        #     "issue" => meta.fetch("issue", nil),
        #     "firstPage" => first_page,
        #     "lastPage" => last_page
        #    }.compact
        # else
        #   nil
        # end

        # identifiers = [normalize_id(meta.fetch("id", nil)), normalize_doi(meta.fetch("DOI", nil))].compact.map do |r|
        #   r = normalize_id(r)

        #   if r.start_with?("https://doi.org")
        #     { "identifierType" => "DOI", "identifier" => r }
        #   else
        #       { "identifierType" => "URL", "identifier" => r }
        #   end
        # end.uniq

        # id = Array.wrap(identifiers).first.to_h.fetch("identifier", nil)
        # doi = Array.wrap(identifiers).find { |r| r["identifierType"] == "DOI" }.to_h.fetch("identifier", nil)

        # state = id.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.fetch('keywords', nil)).map do |s|
          { 'subject' => s }
        end

        {
          # "id" => id,
          # "identifiers" => identifiers,
          'type' => type,
          # "doi" => doi_from_url(doi),
          # "url" => normalize_id(meta.fetch("URL", nil)),
          'titles' => [{ 'title' => meta.fetch('name', nil) }],
          'contributors' => contributors,
          # "contributors" => contributors,
          # "container" => container,
          # "publisher" => meta.fetch("publisher", nil),
          # "related_identifiers" => related_identifiers,
          # "dates" => dates,
          'descriptions' => if meta.fetch('description', nil).present?
                              [{ 'description' => sanitize(meta.fetch('description')),
                                 'descriptionType' => 'Abstract' }]
                            else
                              []
                            end,
          'license' => license,
          'version' => meta.fetch('version', nil),
          'subjects' => subjects
          # "state" => state
        }.merge(read_options)
      end
    end
  end
end
