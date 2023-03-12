# frozen_string_literal: true

module Briard
  module Readers
    module DataciteReader
      def get_datacite(id: nil, **options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        api_url = datacite_api_url(id, options)
        conn = Faraday.new(api_url, request: { timeout: 5 }) do |f|
          f.request :gzip
          f.request :json
          # f.response :json
        end
        response = conn.get(api_url)
        body = JSON.parse(response.body)
        attributes = body.dig("data", "attributes")
        return { "string" => nil, "state" => "not_found" } unless attributes.present?

        # remove the base64 encoded xml
        attributes.delete("xml")
        # convert the attributes to json for consitency with other readers
        string = attributes.to_json

        client = Array.wrap(body.fetch("included", nil)).find do |m|
          m["type"] == "clients"
        end
        client_id = client.to_h.fetch("id", nil)
        provider_id = Array.wrap(client.to_h.fetch("relationships", nil)).find do |m|
          m["provider"].present?
        end.to_h.dig("provider", "data", "id")

        content_url = attributes.fetch("contentUrl",
                                       nil) || Array.wrap(body.fetch("included",
                                                                     nil)).select do |m|
          m["type"] == "media"
        end.map do |m|
          m.dig("attributes", "url")
        end.compact

        { "string" => string,
          "url" => attributes.fetch("url", nil),
          "state" => attributes.fetch("state", nil),
          "date_registered" => attributes.fetch("registered", nil),
          "date_updated" => attributes.fetch("updated", nil),
          "provider_id" => provider_id,
          "client_id" => client_id,
          "content_url" => content_url }
      end

      def read_datacite(string: nil, **_options)
        errors = jsonlint(string)
        return { "errors" => errors } if errors.present?
        read_options = ActiveSupport::HashWithIndifferentAccess.new(_options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        meta = string.present? ? JSON.parse(string).transform_keys!(&:underscore) : {}
        
        id = normalize_doi(meta.fetch("doi", nil))
        types = meta.fetch("types", nil)
        identifiers = meta.fetch("identifiers", nil)
        url = meta.fetch("url", nil)
        titles = Array.wrap(meta.fetch("titles", nil)).map do |title|
          title.compact
        end
        creators = get_authors(meta.fetch("creators", nil))
        publisher = meta.fetch("publisher", nil)
        publication_year = meta.fetch("publication_year", "").to_i

        contributors = get_authors(meta.fetch("contributors", nil))
        container = meta.fetch("container", nil)
        funding_references = meta.fetch("funding_references", nil)
        dates = Array.wrap(meta.fetch("dates", nil)).map do |date|
          date.compact
        end
        descriptions = Array.wrap(meta.fetch("descriptions", nil)).map do |description|
          description.compact
        end
        rights_list = Array.wrap(meta.dig("rights_list")).map do |r|
          if r.blank?
            nil
          elsif r.is_a?(String)
            name_to_spdx(r)
          elsif r.is_a?(Hash)
            hsh_to_spdx(r)
          end
        end.compact
        version_info = meta.fetch("version", nil)
        subjects = meta.fetch("subjects", nil)
        language = meta.fetch("language", nil)
        geo_locations = meta.fetch("geo_locations", nil)
        related_identifiers = meta.fetch("related_identifiers", nil)
        related_items = meta.fetch("related_items", nil)
        formats = meta.fetch("formats", nil)
        sizes = meta.fetch("sizes", nil)
        schema_version = meta.fetch("schema_version", nil) || "http://datacite.org/schema/kernel-4"
        state = id.present? || read_options.present? ? "findable" : "not_found"

        { "id" => id,
          "types" => types,
          "doi" => doi_from_url(id),
          "identifiers" => identifiers,
          "url" => url,
          "titles" => titles,
          "creators" => creators,
          "contributors" => contributors,
          "container" => container,
          "publisher" => publisher,
          "agency" => "DataCite",
          "funding_references" => funding_references,
          "dates" => dates,
          "publication_year" => publication_year.presence,
          "descriptions" => descriptions,
          "rights_list" => rights_list,
          "version_info" => version_info,
          "subjects" => subjects,
          "language" => language,
          "geo_locations" => geo_locations,
          "related_identifiers" => related_identifiers,
          "related_items" => related_items,
          "formats" => formats,
          "sizes" => sizes,
          "schema_version" => schema_version,
          "state" => state }.compact #.merge(read_options)
      end

      def format_contributor(contributor)
        { "name" => contributor.fetch("name", nil),
          "nameType" => contributor.fetch("nameType", nil),
          "givenName" => contributor.fetch("givenName", nil),
          "familyName" => contributor.fetch("familyName", nil),
          "nameIdentifiers" => contributor.fetch("nameIdentifiers", nil).presence,
          "affiliations" => contributor.fetch("affiliations", nil).presence,
          "contributorType" => contributor.fetch("contributorType", nil) }.compact
      end
    end
  end
end
