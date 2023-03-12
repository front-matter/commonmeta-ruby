# frozen_string_literal: true

module Briard
  module Readers
    module DataciteReader
      def get_datacite(id: nil, **options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        api_url = datacite_api_url(id, options)
        response = Maremma.get(api_url)
        attributes = response.body.dig("data", "attributes")
        return { "string" => nil, "state" => "not_found" } unless attributes.present?

        string = attributes.to_json

        client = Array.wrap(response.body.fetch("included", nil)).find do |m|
          m["type"] == "clients"
        end
        client_id = client.to_h.fetch("id", nil)
        provider_id = Array.wrap(client.to_h.fetch("relationships", nil)).find do |m|
          m["provider"].present?
        end.to_h.dig("provider", "data", "id")

        content_url = attributes.fetch("contentUrl",
                                       nil) || Array.wrap(response.body.fetch("included",
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
        # errors = jsonlint(string)
        # return { 'errors' => errors } if errors.present?
        # read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
        #   :sandbox, :validate, :ra))
        read_options = {}

        meta = string.present? ? Maremma.from_json(string).transform_keys!(&:underscore) : {}

        id = normalize_doi(meta.fetch("doi", nil))
        types = meta.fetch("types", nil)
        identifiers = meta.fetch("identifiers", nil)
        url = meta.fetch("url", nil)
        titles = Array.wrap(meta.fetch("titles", nil)). map do |title|
          title.compact
        end
        creators = Array.wrap(meta.fetch("creators", nil)).map do |creator|
          format_contributor(creator)
        end
        publisher = meta.fetch("publisher", nil)
        publication_year = meta.fetch("publication_year", '').to_i

        contributors = Array.wrap(meta.fetch("contributors", nil)).map do |contributor|
          format_contributor(contributor)
        end
        container = meta.fetch("container", nil)
        funding_references = meta.fetch("funding_references", nil)
        dates = Array.wrap(meta.fetch("dates", nil)).map do |date|
          date.compact
        end
        descriptions = Array.wrap(meta.fetch("descriptions", nil)).map do |description|
          description.compact
        end
        rights_list = meta.fetch("rights_list", nil)
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
