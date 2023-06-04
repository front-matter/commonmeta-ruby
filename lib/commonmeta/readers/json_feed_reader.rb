# frozen_string_literal: true

module Commonmeta
  module Readers
    module JsonFeedReader
      def get_json_feed_item(id: nil, **_options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        url = normalize_id(id)
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?
  
        { "string" => response.body.to_s }
      end

      def read_json_feed_item(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        id = options[:doi] ? normalize_doi(options[:doi]) : normalize_id(meta.fetch("id", nil))
        url = normalize_url(meta.fetch("url", nil))
        type = "Article"
        creators = if meta.fetch("authors", nil).present?
            get_authors(from_json_feed(Array.wrap(meta.fetch("authors"))))
          else
            [{ "type" => "Organization", "name" => ":(unav)" }]
          end
        titles = [{ "title" => meta.fetch("title", nil) }]
        publisher = { "name" => meta.dig("blog", "title") }

        date = {}
        date["published"] = get_iso8601_date(meta.dig("date_published")) if meta.dig("date_published").present?
        date["updated"] = get_iso8601_date(meta.dig("date_modified")) if meta.dig("date_modified").present?

        license = if meta.dig("blog", "license").present?
            hsh_to_spdx("rightsURI" => meta.dig("blog", "license"))
          end
        home_page_url = normalize_url(meta.dig("blog", "home_page_url"))
        container = if meta.dig("blog", "title").present?
            { "type" => "Periodical",
              "title" => meta.dig("blog", "title"),
              "identifier" => home_page_url,
              "identifierType" => "URL" }
          end

        descriptions = if meta.fetch("summary", nil).present?
            [{ "description" => sanitize(meta.fetch("summary", nil)),
               "descriptionType" => "Abstract" }]
          else
            []
          end
        language = meta.fetch("language", nil) || meta.fetch("blog", "language", nil)
        state = id.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.fetch("tags", nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        { "id" => id,
          "type" => type,
          "url" => url,
          "titles" => titles,
          "creators" => creators,
          "publisher" => publisher,
          "container" => container,
          "date" => date,
          "language" => language,
          "descriptions" => descriptions,
          "license" => license,
          "subjects" => subjects.presence,
          "state" => state }.compact.merge(read_options)
      end

      def get_json_feed(id)
        # get JSON Feed items not registered as DOIs
        return { "string" => nil, "state" => "not_found" } unless id.present?

        url = json_feed_url(id)
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        blog = JSON.parse(response.body.to_s)
        blog["items"].select { |item| !validate_doi(item["id"]) }.map { |item| item["short_id"] }.join(",").presence
      end
    end
  end
end