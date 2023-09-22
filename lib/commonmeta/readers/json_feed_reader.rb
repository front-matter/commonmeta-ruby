# frozen_string_literal: true
require "uri"

module Commonmeta
  module Readers
    module JsonFeedReader
      def get_json_feed_item(id: nil, **options)
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

        if (meta.dig("blog", "status") == "archived")
          url = normalize_url(meta.fetch("archive_url", nil))
        else
          url = normalize_url(meta.fetch("url", nil))
        end
        id = options[:doi] ? normalize_doi(options[:doi]) : normalize_id(meta.fetch("doi", nil))
        id = normalize_url(meta.fetch("url", nil)) if id.blank?

        type = "Article"
        contributors = if meta.fetch("authors", nil).present?
            get_authors(from_json_feed(Array.wrap(meta.fetch("authors"))))
          else
            [{ "type" => "Organization", "name" => ":(unav)" }]
          end
        titles = [{ "title" => meta.fetch("title", nil) }]
        publisher = { "name" => meta.dig("blog", "title") }

        date = {}
        date["published"] = get_date_from_unix_timestamp(meta.dig("published_at")) if meta.dig("published_at").present?
        date["updated"] = get_date_from_unix_timestamp(meta.dig("updated_at")) if meta.dig("updated_at").present?

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
          sum += name_to_fos(subject.underscore.humanize)

          sum
        end
        references = get_references(meta)
        funding_references = get_funding_references(meta)
        related_identifiers = get_related_identifiers(meta)
        alternate_identifiers = [{ "alternateIdentifier" => meta["id"], "alternateIdentifierType" => "UUID" }]

        { "id" => id,
          "type" => type,
          "url" => url,
          "titles" => titles,
          "contributors" => contributors,
          "publisher" => publisher,
          "container" => container,
          "date" => date,
          "language" => language,
          "descriptions" => descriptions,
          "license" => license,
          "subjects" => subjects.presence,
          "references" => references.presence,
          "funding_references" => funding_references.presence,
          "related_identifiers" => related_identifiers.presence,
          "alternate_identifiers" => alternate_identifiers,
          "state" => state }.compact.merge(read_options)
      end

      def get_references(meta)
        # check that references resolve
        Array.wrap(meta["reference"]).reduce([]) do |sum, reference|
          begin
            if reference["doi"] && validate_doi(reference["doi"])
              response = HTTP.follow
                .headers(:accept => "application/vnd.citationstyles.csl+json")
                .get(reference["doi"])
              csl = JSON.parse(response.body.to_s)
              sum << reference.merge("title" => csl["title"], "publicationYear" => csl.dig("issued", "date-parts", 0, 0).to_s) if [200, 301, 302].include? response.status
            elsif reference["url"] && validate_url(reference["url"]) == "URL"
              sum << reference if [200, 301, 302].include? HTTP.head(reference["url"]).status
            end
          rescue => error
            # puts "Error: #{error.message}"
            # puts "Error: #{reference}"
          end

          sum
        end
      end

      def get_related_identifiers(meta)
        # check that relationships resolve and has a supported type
        supported_types = %w[IsIdenticalTo IsPreprintOf IsTranslationOf]
        Array.wrap(meta["relationships"]).reduce([]) do |sum, relationship|
          begin
            if supported_types.include?(relationship["type"]) && [200, 301, 302].include?(HTTP.head(relationship["url"]).status)
              sum << { "id" => relationship["url"], "type" => relationship["type"] }
            end
          rescue => error
            # puts "Error: #{error.message}"
            # puts "Error: #{reference}"
          end

          sum
        end
      end

      def get_funding_references(meta)
        # check that relationships resolve and have type "HasAward" or funding is provided by blog metadata
        if funding = meta.dig("blog", "funding")
          fundref = { 
            "funderIdentifier" => funding["funder_id"],
            "funderIdentifierType" => "Crossref Funder ID",
            "funderName" => funding["funder_name"], 
            "awardNumber" => funding["award_number"]
          }

        else
          fundref = nil
        end
        Array.wrap(fundref) + Array.wrap(meta["relationships"]).reduce([]) do |sum, relationship|
          begin
            # funder is European Commission
            if validate_prefix(relationship["url"]) == "10.3030" || URI.parse(relationship["url"]).host == "cordis.europa.eu"
              relationship["funderIdentifier"] = "http://doi.org/10.13039/501100000780"
              relationship["funderName"] = "European Commission"
              relationship["awardNumber"] = relationship["url"].split("/").last
            end
            if relationship["type"] == "HasAward" && relationship["funderName"]
              sum << {
                "funderIdentifier" => relationship["funderIdentifier"],
                "funderName" => relationship["funderName"],
                "awardNumber" => relationship["awardNumber"],
              }
            end
          rescue => error
            # puts "Error: #{error.message}"
            # puts "Error: #{reference}"
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
        posts.map { |post| post["id"] }.first
      end

      def get_json_feed_not_indexed
        # get JSON Feed items not indexed in Crossref since they have been last updated

        url = json_feed_not_indexed_url
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        posts = JSON.parse(response.body.to_s)
        posts.map { |post| post["id"] }.first
      end

      def get_json_feed_by_blog(blog_id)
        # get all JSON Feed items from a particular blog

        url = json_feed_by_blog_url(blog_id)
        response = HTTP.get(url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        blog = JSON.parse(response.body.to_s)
        blog["items"].map { |item| item["id"] }.first
      end

      def get_doi_prefix_by_blog_id(blog_id)
        # for generating a random DOI.

        url = json_feed_by_blog_url(blog_id)
        response = HTTP.get(url)
        return nil unless response.status.success?

        post = JSON.parse(response.body.to_s)
        post.to_h.dig("prefix")
      end

      def get_doi_prefix_by_json_feed_item_id(id)
        # for generating a random DOI. Prefix is based on the blog id.

        url = json_feed_item_by_id_url(id)
        response = HTTP.get(url)
        return nil unless response.status.success?

        post = JSON.parse(response.body.to_s)
        post.to_h.dig("blog", "prefix")
      end
    end
  end
end
