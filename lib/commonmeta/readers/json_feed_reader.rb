# frozen_string_literal: true
require "uri"

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
        language = meta.fetch("language", nil) || meta.dig("blog", "language")
        state = id.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.dig("blog", "category")).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end
        references = get_references(meta)
        alternate_identifiers = [{ "alternateIdentifier" => meta["uuid"], "alternateIdentifierType" => "UUID" }]

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
          "references" => references.presence,
          "alternate_identifiers" => alternate_identifiers,
          "state" => state }.compact.merge(read_options)
      end

      def get_references(meta)
        # check that references resolve
        Array.wrap(meta["references"]).reduce([]) do |sum, reference|
          if reference["doi"] && validate_doi(reference["doi"])
            sum << reference if [200, 301, 302].include? HTTP.head(reference["doi"]).status
          elsif reference["url"] && validate_url(reference["url"]) == "URL"
            sum << reference if [200, 301, 302].include? HTTP.head(reference["url"]).status
          end

          sum
        end
      end

      def get_json_feed_unregistered
        # get JSON Feed items not registered as DOIs

        url = json_feed_unregistered_url
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        posts = JSON.parse(response.body.to_s)
        posts.map { |post| post["uuid"] }.first
      end

      def get_json_feed_not_indexed(date_indexed)
        # get JSON Feed items not indexed in Crossref since a particular date

        url = json_feed_not_indexed_url(date_indexed)
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        posts = JSON.parse(response.body.to_s)
        posts.map { |post| post["uuid"] }.first
      end

      def get_json_feed_by_blog(blog_id)
        # get all JSON Feed items from a particular blog

        url = json_feed_by_blog_url(blog_id)
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        blog = JSON.parse(response.body.to_s)
        blog["items"].map { |item| item["uuid"] }.first
      end
    end
  end
end
