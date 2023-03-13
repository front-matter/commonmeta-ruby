# frozen_string_literal: true

module Briard
  module Readers
    module CrossrefXmlReader
      # CrossRef types from https://api.crossref.org/types
      def get_crossref_xml(id: nil, **_options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        doi = doi_from_url(id)
        api_url = "https://api.crossref.org/works/#{doi}/transform/application/vnd.crossref.unixsd+xml"
        response = HTTP.get(api_url)
        return { "string" => nil, "state" => "not_found" } unless response.status.success?

        { "string" => response.body.to_s }
      end

      def read_crossref_xml(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        if string.present?
          # query contains information from outside metadata schema, e.g. publisher name
          query = Hash.from_xml(string).dig("crossref_result", "query_result", "body", "query")
          meta = query.dig("doi_record", "crossref", "error").nil? ? query.dig("doi_record") : {}
        else
          meta = {}
          query = {}
        end

        # model should be one of book, conference, database, dissertation, journal, peer_review, posted_content,
        # report_paper, sa_component, standard
        model = meta["crossref"].to_h.keys.first

        resource_type = nil
        bibmeta = {}
        program_metadata = {}
        journal_metadata = nil
        journal_issue = {}
        journal_metadata = nil
        publisher = query.dig("crm_item", 0)
        publisher = nil unless publisher.is_a?(String)

        case model
        when "book"
          book_metadata = meta.dig("crossref", "book", "book_metadata")
          book_series_metadata = meta.dig("crossref", "book", "book_series_metadata")
          book_set_metadata = meta.dig("crossref", "book", "book_set_metadata")
          bibmeta = meta.dig("crossref", "book",
                             "content_item") || book_metadata || book_series_metadata || book_set_metadata
          resource_type = if bibmeta.fetch("component_type", nil)
              "book-#{bibmeta.fetch("component_type")}"
            else
              "book"
            end
          # publisher = if book_metadata.present?
          #               book_metadata.dig("publisher", "publisher_name")
          #             elsif book_series_metadata.present?
          #               book_series_metadata.dig("publisher", "publisher_name")
          #             end
        when "conference"
          event_metadata = meta.dig("crossref", "conference", "event_metadata") || {}
          bibmeta = meta.dig("crossref", "conference", "conference_paper").to_h
        when "journal"
          journal_metadata = meta.dig("crossref", "journal", "journal_metadata") || {}
          journal_issue = meta.dig("crossref", "journal", "journal_issue") || {}
          journal_article = meta.dig("crossref", "journal", "journal_article") || {}
          bibmeta = journal_article.presence || journal_issue.presence || journal_metadata
          program_metadata = bibmeta.dig("crossmark", "custom_metadata",
                                         "program") || bibmeta["program"]
          resource_type = if journal_article.present?
              "journal_article"
            elsif journal_issue.present?
              "journal_issue"
            else
              "journal"
            end
        when "posted_content"
          bibmeta = meta.dig("crossref", "posted_content").to_h
          publisher ||= bibmeta.dig("institution", "institution_name")
        when "sa_component"
          bibmeta = meta.dig("crossref", "sa_component", "component_list",
                             "component").to_h
          related_identifier = Array.wrap(query.to_h["crm_item"]).find do |cr|
            cr["name"] == "relation"
          end
          journal_metadata = { "relatedIdentifier" => related_identifier.to_h.fetch("__content",
                                                                                   nil) }
        when "database"
          bibmeta = meta.dig("crossref", "database", "dataset").to_h
          resource_type = "dataset"
        when "report_paper"
          bibmeta = meta.dig("crossref", "report_paper",
                             "report_paper_metadata").to_h
          resource_type = "report"
        when "peer_review"
          bibmeta = meta.dig("crossref", "peer_review")
        when "dissertation"
          bibmeta = meta.dig("crossref", "dissertation")
        end

        resource_type = (resource_type || model).to_s.underscore.camelcase.presence
        schema_org = Briard::Utils::CR_TO_SO_TRANSLATIONS[resource_type] || "CreativeWork"
        types = {
          "resourceTypeGeneral" => Briard::Utils::CR_TO_DC_TRANSLATIONS[resource_type],
          "resourceType" => resource_type,
          "schemaOrg" => schema_org,
          "citeproc" => Briard::Utils::CR_TO_CP_TRANSLATIONS[resource_type] || "article-journal",
          "bibtex" => Briard::Utils::CR_TO_BIB_TRANSLATIONS[resource_type] || "misc",
          "ris" => Briard::Utils::CR_TO_RIS_TRANSLATIONS[resource_type] || "GEN",
        }.compact

        titles = if bibmeta["titles"].present?
            Array.wrap(bibmeta["titles"]).map do |r|
              if r.blank? || (r["title"].blank? && r["original_language_title"].blank?)
                nil
              elsif r["title"].is_a?(String)
                { "title" => sanitize(r["title"]) }
              elsif r["original_language_title"].present?
                { "title" => sanitize(r.dig("original_language_title", "__content__")),
                  "lang" => r.dig("original_language_title", "language") }
              else
                { "title" => sanitize(r.dig("title", "__content__")) }.compact
              end
            end.compact
          else
            [{ "title" => ":(unav)" }]
          end

        date_published = crossref_date_published(bibmeta)
        if date_published.present?
          date_published = { "date" => date_published, "dateType" => "Issued" }
        else
          date_published = Array.wrap(query.to_h["crm_item"]).find { |cr| cr["name"] == "created" }
          if date_published.present?
            date_published = { "date" => date_published.fetch("__content__", "")[0..9],
                               "dateType" => "Issued" }
          end
        end
        date_updated = Array.wrap(query.to_h["crm_item"]).find { |cr| cr["name"] == "last-update" }

        if date_updated.present?
          date_updated = { "date" => date_updated.fetch("__content__", nil),
                           "dateType" => "Updated" }
        end

        date_registered = Array.wrap(query.to_h["crm_item"]).find do |cr|
          cr["name"] == "deposit-timestamp"
        end
        if date_registered.present?
          date_registered = get_datetime_from_time(date_registered.fetch("__content__", nil))
        end

        # check that date is valid iso8601 date
        date_published = nil unless Date.edtf(date_published.to_h["date"]).present?
        date_updated = nil unless Date.edtf(date_updated.to_h["date"]).present?

        # TODO: fix timestamp. Until then, remove time as this is not always stable with Crossref (different server timezones)
        date_published["date"] = get_iso8601_date(date_published["date"]) if date_published.present?
        date_updated["date"] = get_iso8601_date(date_updated["date"]) if date_updated.present?

        dates = [date_published, date_updated].compact
        publication_year = date_published.to_h.fetch("date", "")[0..3].to_i.presence

        state = meta.present? || read_options.present? ? "findable" : "not_found"

        related_identifiers = Array.wrap(crossref_references(bibmeta))

        container = if journal_metadata.present?
            issn = normalize_issn(journal_metadata.to_h.fetch("issn", nil))

            { "type" => "Journal",
              "identifier" => issn,
              "identifierType" => issn.present? ? "ISSN" : nil,
              "title" => parse_attributes(journal_metadata.to_h["full_title"]),
              "volume" => parse_attributes(journal_issue.dig("journal_volume", "volume")),
              "issue" => parse_attributes(journal_issue["issue"]),
              "firstPage" => bibmeta.dig("pages",
                                         "first_page") || parse_attributes(journal_article.to_h.dig("publisher_item", "item_number"),
                                                                           first: true),
              "lastPage" => bibmeta.dig("pages", "last_page") }.compact

            # By using book_metadata, we can account for where resource_type is `BookChapter` and not assume its a whole book
          elsif book_metadata.present?
            identifiers = crossref_alternate_identifiers(book_metadata)

            {
              "type" => "Book",
              "title" => book_metadata.dig("titles", "title"),
              "firstPage" => bibmeta.dig("pages", "first_page"),
              "lastPage" => bibmeta.dig("pages", "last_page"),
              "identifiers" => identifiers,
            }.compact
          elsif book_series_metadata.to_h.fetch("series_metadata", nil).present?
            issn = normalize_issn(book_series_metadata.dig("series_metadata", "issn"))

            { "type" => "Book Series",
              "identifier" => issn,
              "identifierType" => issn.present? ? "ISSN" : nil,
              "title" => book_series_metadata.dig("series_metadata", "titles", "title"),
              "volume" => bibmeta.fetch("volume", nil) }.compact
          end

        id = normalize_doi(options[:doi] || options[:id] || bibmeta.dig("doi_data",
                                                                        "doi"))

        # Let sections override this in case of alternative metadata structures, such as book chapters, which
        # have their meta inside `content_item`, but the main book indentifers inside of `book_metadata`
        identifiers ||= crossref_alternate_identifiers(bibmeta)

        url = parse_attributes(bibmeta.dig("doi_data", "resource"),
                               first: true)
        url = normalize_url(url) if url.present?

        { "id" => id,
          "types" => types,
          "doi" => doi_from_url(id),
          "url" => url,
          "titles" => titles,
          "identifiers" => identifiers,
          "creators" => crossref_people(bibmeta, "author"),
          "contributors" => crossref_people(bibmeta, "editor"),
          "funding_references" => crossref_funding_reference(program_metadata),
          "publisher" => publisher,
          "container" => container,
          "agency" => agency = options[:ra] || get_doi_ra(id) || "Crossref",
          "related_identifiers" => related_identifiers,
          "dates" => dates,
          "publication_year" => publication_year,
          "descriptions" => crossref_description(bibmeta),
          "rights_list" => crossref_license(program_metadata),
          "version_info" => nil,
          "subjects" => nil,
          "language" => nil,
          "sizes" => nil,
          "schema_version" => "http://datacite.org/schema/kernel-4",
          "state" => state,
          "date_registered" => date_registered }.compact.merge(read_options)
      end

      def crossref_alternate_identifiers(bibmeta)
        if bibmeta.dig("publisher_item", "item_number").present?
          Array.wrap(bibmeta.dig("publisher_item", "item_number")).map do |item|
            if item.is_a?(String)
              { "identifier" => item,
                "identifierType" => "Publisher ID" }
            else
              { "identifier" => item.fetch("__content__", nil),
                "identifierType" => item.fetch("item_number_type", nil) || "Publisher ID" }
            end
          end
        elsif parse_attributes(bibmeta.fetch("item_number", nil)).present?
          [{ "identifier" => parse_attributes(bibmeta.fetch("item_number", nil)),
            "identifierType" => parse_attributes(bibmeta.dig("item_number",
                                                             "item_number_type")) || "Publisher ID" }]
        elsif parse_attributes(bibmeta.fetch("isbn", nil)).present?
          [{ "identifier" => parse_attributes(bibmeta.fetch("isbn", nil), first: true),
             "identifierType" => "ISBN" }]
        else
          []
        end
      end

      def crossref_description(bibmeta)
        abstract = Array.wrap(bibmeta["abstract"]).map do |r|
          { "descriptionType" => "Abstract",
            "description" => sanitize(parse_attributes(r, content: "p")) }.compact
        end

        description = Array.wrap(bibmeta["description"]).map do |r|
          { "descriptionType" => "Other", "description" => sanitize(parse_attributes(r)) }.compact
        end

        (abstract + description)
      end

      def crossref_license(program_metadata)
        access_indicator = Array.wrap(program_metadata).find { |m| m["name"] == "AccessIndicators" }
        if access_indicator.present?
          Array.wrap(access_indicator["license_ref"]).map do |license|
            hsh_to_spdx("rightsURI" => parse_attributes(license))
          end.uniq
        else
          []
        end
      end

      def crossref_people(bibmeta, contributor_role)
        person = bibmeta.dig("contributors",
                             "person_name") || bibmeta["person_name"]
        organization = Array.wrap(bibmeta.dig("contributors", "organization"))
        if contributor_role == "author" && Array.wrap(person).select do |a|
          a["contributor_role"] == "author"
        end.blank? && Array.wrap(organization).select do |a|
          a["contributor_role"] == "author"
        end.blank?
          person = [{ "name" => ":(unav)", "contributor_role" => "author" }]
        end

        (Array.wrap(person) + Array.wrap(organization)).select do |a|
          a["contributor_role"] == contributor_role
        end.map do |a|
          name_identifiers = if normalize_orcid(parse_attributes(a["ORCID"])).present?
              [{
                "nameIdentifier" => normalize_orcid(parse_attributes(a["ORCID"])), "nameIdentifierScheme" => "ORCID", "schemeUri" => "https://orcid.org",
              }]
            end
          if a["surname"].present? || a["given_name"].present? || name_identifiers.present?
            given_name = parse_attributes(a["given_name"])
            family_name = parse_attributes(a["surname"])
            affiliation = Array.wrap(a["affiliation"]).map do |a|
              if a.is_a?(Hash)
                a
              elsif a.is_a?(Hash) && a.key?("__content__") && a["__content__"].strip.blank?
                nil
              elsif a.is_a?(Hash) && a.key?("__content__")
                { "name" => a["__content__"] }
              elsif a.strip.blank?
                nil
              elsif a.is_a?(String)
                { "name" => a }
              end
            end.compact

            { "nameType" => "Personal",
              "nameIdentifiers" => name_identifiers,
              "name" => [family_name, given_name].compact.join(", "),
              "givenName" => given_name,
              "familyName" => family_name,
              "affiliation" => affiliation.presence,
              "contributorType" => contributor_role == "editor" ? "Editor" : nil }.compact
          else
            { "nameType" => "Organizational",
              "name" => a["name"] || a["__content__"],
              "contributorType" => contributor_role == "editor" ? "Editor" : nil }.compact
          end
        end
      end

      def crossref_funding_reference(program_metadata)
        fundref = Array.wrap(program_metadata).find { |a| a["name"] == "fundref" } || {}
        Array.wrap(fundref.fetch("assertion", [])).select do |a|
          a["name"] == "fundgroup" && a["assertion"].present?
        end.map do |f|
          funder_identifier = nil
          funder_identifier_type = nil
          funder_name = nil
          award_title = nil
          award_number = nil
          award_uri = nil

          Array.wrap(f.fetch("assertion")).each do |a|
            case a.fetch("name")
            when "award_number"
              award_number = a.fetch("__content__", nil)
              award_uri = a.fetch("awardURI", nil)
            when "funder_name"
              funder_name = a.fetch("__content__", nil).to_s.squish.presence
              funder_identifier = validate_funder_doi(a.dig("assertion", "__content__"))
              funder_identifier_type = "Crossref Funder ID" if funder_identifier.present?
            end
          end

          # funder_name is required in DataCite
          next unless funder_name.present?

          { "funderIdentifier" => funder_identifier,
            "funderIdentifierType" => funder_identifier_type,
            "funderName" => funder_name,
            "awardTitle" => award_title,
            "awardNumber" => award_number,
            "awardUri" => award_uri }.compact
        end.compact
      end

      def crossref_date_published(bibmeta)
        pub_date = Array.wrap(bibmeta.fetch("publication_date", nil)).presence ||
                   Array.wrap(bibmeta.fetch("acceptance_date", nil))
        return unless pub_date.present?

        get_date_from_parts(pub_date.first["year"], pub_date.first["month"], pub_date.first["day"])
      end

      def crossref_references(bibmeta)
        refs = bibmeta.dig("citation_list", "citation")
        Array.wrap(refs).select { |a| a["doi"].present? }.map do |c|
          next unless c["doi"].present?

          { "relatedIdentifier" => parse_attributes(c["doi"]).downcase,
            "relationType" => "References",
            "relatedIdentifierType" => "DOI" }.compact
        end.compact.unwrap
      end
    end
  end
end
