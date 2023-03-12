# frozen_string_literal: true

module Briard
  module Readers
    module CrossrefReader
      def get_crossref(id: nil, **options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        url = crossref_api_url(id, options)
        response = Maremma.get(url)
        return { "string" => nil, "state" => "not_found" } if response.body.dig("data", "status") != "ok"

        string = response.body.dig("data", "message").to_json

        { "string" => string }
      end

      def read_crossref(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { "errors" => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        meta = string.present? ? Maremma.from_json(string) : {}

        resource_type = meta.fetch("type", nil)
        resource_type = resource_type.present? ? resource_type.underscore.camelcase : nil

        types = {
          "resourceTypeGeneral" => Briard::Utils::CR_TO_DC_TRANSLATIONS[resource_type] || "Text",
          "resourceType" => resource_type,
          "schemaOrg" => Briard::Utils::CR_TO_SO_TRANSLATIONS[resource_type] || "CreativeWork",
          "citeproc" => Briard::Utils::CR_TO_CP_TRANSLATIONS[resource_type] || "article-journal",
          "bibtex" => Briard::Utils::CR_TO_BIB_TRANSLATIONS[resource_type] || "misc",
          "ris" => Briard::Utils::CR_TO_RIS_TRANSLATIONS[resource_type] || "GEN",
        }.compact

        creators = if meta.fetch("author", nil).present?
            get_authors(from_citeproc(Array.wrap(meta.fetch("author", nil))))
          else
            [{ "nameType" => "Organizational", "name" => ":(unav)" }]
          end
        editors = Array.wrap(meta.fetch("editor", nil)).each { |e| e["contributorType"] = "Editor" }
        contributors = get_authors(from_citeproc(editors))

        published_date = get_date_from_date_parts(meta.fetch("issued", nil)) || get_date_from_date_parts(meta.fetch("created", nil))
        updated_date = get_date_from_date_parts(meta.fetch("deposited", nil))
        dates = [{ "date" => published_date, "dateType" => "Issued" }]
        dates << { "date" => updated_date, "dateType" => "Updated" } if updated_date.present?
        publication_year = published_date.to_s[0..3].to_i
        date_registered = get_date_from_date_parts(meta.fetch("registered", nil)) || get_date_from_date_parts(meta.fetch("created", nil))

        rights_list = if meta.fetch("license", nil)
            [hsh_to_spdx("rightsURI" => meta.dig("license", 0, "URL"))]
          end
        issn = Array.wrap(meta.fetch("issn-type", nil)).find { |i| i["type"] == "electronic" } ||
               Array.wrap(meta.fetch("issn-type", nil)).find { |i| i["type"] == "print" } || {}
        issn = issn.fetch("value", nil) if issn.present?

        related_identifiers = if meta.fetch("container-title",
                                            nil).present? && issn.present?
            [{ "relationType" => "IsPartOf",
               "relatedIdentifierType" => "ISSN",
               "resourceTypeGeneral" => "Collection",
               "relatedIdentifier" => issn }.compact]
          else
            []
          end
        related_identifiers += Array.wrap(meta.fetch("reference", nil)).map do |ref|
          doi = ref.fetch("DOI", nil)
          next unless doi.present?

          { "relationType" => "References",
            "relatedIdentifierType" => "DOI",
            "relatedIdentifier" => doi.downcase }
        end.compact

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
        container_type = case resource_type
          when "JournalArticle", "JournalIssue"
            "Journal"
          when "BookChapter"
            "Book"
          when "Monograph"
            "BookSeries"
          else
            nil
          end

        first_page = if meta.fetch("page", nil).present?
            meta.fetch("page").split("-").map(&:strip)[0]
          end
        last_page = if meta.fetch("page", nil).present?
            meta.fetch("page").split("-").map(&:strip)[1]
          end

        container = { "type" => container_type,
                      "title" => parse_attributes(meta.fetch("container-title", nil), first: true).to_s.squish.presence,
                      "identifier" =>issn.present? ? issn : nil,
                      "identifierType" => issn.present? ? "ISSN" : nil,
                      "volume" => meta.fetch("volume", nil),
                      "issue" => meta.fetch("issue", nil),
                      "firstPage" => first_page,
                      "lastPage" => last_page }.compact

        id = normalize_id(meta.fetch("id", nil) || meta.fetch("DOI", nil))

        id = normalize_doi(options[:doi] || options[:id] || meta.fetch("DOI", nil))
        title = meta.fetch("title", nil).is_a?(Array) ? meta.fetch("title", nil)[0] : meta.fetch("title", nil)
        title = title.blank? ? ":(unav)" : title.squish
        state = meta.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.fetch("categories", nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end
        abstract = meta.fetch("abstract", nil)
        agency = get_doi_ra(id)

        { "id" => id,
          "types" => types,
          "doi" => doi_from_url(id),
          "url" => normalize_id(meta.dig("resource", "primary", "URL")),
          "titles" => [{ "title" => title }],
          "creators" => creators,
          "contributors" => contributors,
          "container" => container,
          "publisher" => meta.fetch("publisher", nil),
          "related_identifiers" => related_identifiers,
          "dates" => dates,
          "publication_year" => publication_year,
          "descriptions" => if abstract.present?
          [{ "description" => sanitize(abstract),
             "descriptionType" => "Abstract" }]
        else
          []
        end,
          "rights_list" => rights_list,
          "identifiers" => [],
          "funding_references" => funding_references,
          "version_info" => meta.fetch("version", nil),
          "subjects" => subjects,
          "agency" => agency,
          "date_registered" => date_registered,
          "schema_version" => "http://datacite.org/schema/kernel-4",
          "state" => state }.merge(read_options)
      end
    end
  end
end
