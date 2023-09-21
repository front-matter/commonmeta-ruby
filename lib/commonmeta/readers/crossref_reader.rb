# frozen_string_literal: true

module Commonmeta
  module Readers
    module CrossrefReader
      def get_crossref(id: nil, **options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        api_url = crossref_api_url(id, options)
        response = HTTP.get(api_url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        { "string" => response.body.to_s }
      end

      def read_crossref(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { "errors" => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        meta = string.present? ? JSON.parse(string) : {}

        # optionally strip out the message wrapper from API
        meta = meta.dig("message") if meta.dig("message").present?

        resource_type = meta.fetch("type", nil)
        resource_type = resource_type.present? ? resource_type.underscore.camelcase : nil
        type = Commonmeta::Utils::CR_TO_CM_TRANSLATIONS.fetch(resource_type, "Other")

        member_id = meta.fetch("member", nil)
        # TODO: get publisher from member_id almost always return publisher name, but sometimes does not
        publisher = if member_id.present?
            get_crossref_member(member_id)
          else
            meta.fetch("publisher", nil)
          end

        contributors = if meta.fetch("author", nil).present?
            get_authors(from_csl(Array.wrap(meta.fetch("author", nil))))
          else
            []
          end
        editors = Array.wrap(meta.fetch("editor", nil)).each { |e| e["contributorType"] = "Editor" }
        contributors += get_authors(from_csl(editors))

        date = {}
        date["submitted"] = nil
        date["accepted"] = meta.dig("accepted", "date-time")
        date["published"] =
          meta.dig("issued",
                   "date-time") || get_date_from_date_parts(meta.fetch("issued",
                                                                       nil)) || get_date_from_date_parts(meta.fetch(
            "created", nil
          ))
        date["updated"] =
          meta.dig("updated",
                   "date-time") || meta.dig("deposited",
                                            "date-time") || get_date_from_date_parts(meta.fetch(
            "deposited", nil
          ))

        # TODO: fix timestamp. Until then, remove time as this is not always stable with Crossref (different server timezones)
        date["published"] = get_iso8601_date(date["published"]) if date["published"].present?
        date["updated"] = get_iso8601_date(date["updated"]) if date["updated"].present?

        license = if meta.fetch("license", nil)
            hsh_to_spdx("rightsURI" => meta.dig("license", 0, "URL"))
          end
        issn = Array.wrap(meta.fetch("issn-type", nil)).find { |i| i["type"] == "electronic" } ||
               Array.wrap(meta.fetch("issn-type", nil)).find { |i| i["type"] == "print" } || {}
        issn = issn.fetch("value", nil) if issn.present?

        references = Array.wrap(meta.fetch("reference", nil)).map { |r| get_reference(r) }

        funding_references = Array.wrap(meta.fetch("funder", nil)).reduce([]) do |sum, funding|
          funding_reference = {
            "funderName" => funding["name"],
            "funderIdentifier" => funding["DOI"] ? doi_as_url(funding["DOI"]) : nil,
            "funderIdentifierType" => funding["DOI"].to_s.starts_with?("10.13039") ? "Crossref Funder ID" : nil,
          }.compact
          if funding["name"].present? && funding["award"].present?
            Array.wrap(funding["award"]).each do |award|
              funding_reference["awardNumber"] = award
            end
          end

          sum += [funding_reference] if funding_reference.present?
          sum
        end
        files = Array.wrap(meta.fetch("link", nil)).reduce([]) do |sum, file|
          if file["content-type"] != "unspecified"
            file = { "url" => file.fetch("URL", nil), "mimeType" => file.fetch("content-type", nil) }
            sum += [file]
          end
          sum
        end
        
        container_type = case resource_type
          when "JournalArticle", "JournalIssue"
            "Journal"
          when "BookChapter"
            "Book"
          when "Monograph"
            "BookSeries"
          end

        first_page = if meta.fetch("page", nil).present?
            meta.fetch("page").split("-").map(&:strip)[0]
          end
        last_page = if meta.fetch("page", nil).present?
            meta.fetch("page").split("-").map(&:strip)[1]
          end

        container = { "type" => container_type,
                      "title" => parse_attributes(meta.fetch("container-title", nil),
                                                  first: true).to_s.squish.presence,
                      "identifier" => issn.present? ? issn : nil,
                      "identifierType" => issn.present? ? "ISSN" : nil,
                      "volume" => meta.fetch("volume", nil),
                      "issue" => meta.fetch("issue", nil),
                      "firstPage" => first_page,
                      "lastPage" => last_page }.compact

        id = normalize_id(meta.fetch("id", nil) || meta.fetch("DOI", nil))

        id = normalize_doi(options[:doi] || options[:id] || meta.fetch("DOI", nil))
        title = if meta.fetch("title", nil).is_a?(Array)
            meta.fetch("title", nil)[0]
          else
            meta.fetch("title", nil)
          end
        title = title.blank? ? ":(unav)" : title.squish
        state = meta.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.fetch("categories", nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end
        abstract = meta.fetch("abstract", nil)
        provider = get_doi_ra(id)

        { "id" => id,
          "type" => type,
          "url" => normalize_id(meta.dig("resource", "primary", "URL")),
          "titles" => [{ "title" => title }],
          "contributors" => contributors,
          "container" => container,
          "publisher" => publisher,
          "references" => references,
          "date" => date.compact,
          "descriptions" => if abstract.present?
          [{ "description" => sanitize(abstract),
             "descriptionType" => "Abstract" }]
        else
          []
        end,
          "license" => license,
          "alternate_identifiers" => [],
          "funding_references" => funding_references,
          "files" => files.presence,
          "version" => meta.fetch("version", nil),
          "subjects" => subjects,
          "provider" => provider,
          "schema_version" => "http://datacite.org/schema/kernel-4",
          "state" => state }.compact.merge(read_options)
      end

      def get_reference(reference)
        return nil unless reference.present? || !reference.is_a?(Hash)

        doi = reference.dig("DOI")
        {
          "key" => reference.dig("key"),
          "doi" => doi ? normalize_doi(doi) : nil,
          "contributor" => reference.dig("author"),
          "title" => reference.dig("article-title"),
          "publisher" => reference.dig("publisher"),
          "publicationYear" => reference.dig("year"),
          "volume" => reference.dig("volume"),
          "issue" => reference.dig("issue"),
          "firstPage" => reference.dig("first-page"),
          "lastPage" => reference.dig("last-page"),
          "containerTitle" => reference.dig("journal-title"),
          "edition" => nil,
          "unstructured" => doi.nil? ? reference.dig("unstructured") : nil,
        }.compact
      end
    end
  end
end
