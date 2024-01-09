# frozen_string_literal: true

module Commonmeta
  module CrossrefUtils
    def write_crossref_xml
      @crossref_xml ||= Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
        xml.doi_batch(crossref_root_attributes) do
          xml.head do
            # we use a uuid as batch_id
            xml.doi_batch_id(SecureRandom.uuid)
            xml.timestamp(Time.now.utc.strftime("%Y%m%d%H%M%S"))
            xml.depositor do
              xml.depositor_name(depositor)
              xml.email_address(email)
            end
            xml.registrant(registrant)
          end
          xml.body do
            insert_crossref_work(xml)
          end
        end
      end.to_xml
    end

    def crossref_errors(xml: nil)
      filepath = File.expand_path("../../resources/crossref/crossref5.3.1.xsd", __dir__)
      File.open(filepath, "r") do |f|
        schema = Nokogiri::XML::Schema(f)
      end

      schema.validate(Nokogiri::XML(xml, nil, "UTF-8")).map(&:to_s).unwrap
    rescue Nokogiri::XML::SyntaxError => e
      e.message
    end

    def insert_crossref_work(xml)
      return xml if doi_from_url(id).blank?

      case type
      when "JournalArticle"
        insert_journal(xml)
      when "Article"
        insert_posted_content(xml)
      end
    end

    def insert_journal(xml)
      xml.journal do
        if language.present?
          xml.journal_metadata("language" => language[0..1]) do
            xml.full_title(container["title"])
          end
        else
          xml.journal_metadata do
            xml.full_title(container["title"])
          end
        end
        xml.journal_article("publication_type" => "full_text") do
          insert_crossref_titles(xml)
          insert_crossref_contributors(xml)
          insert_crossref_publication_date(xml)
          insert_crossref_abstract(xml)
          insert_crossref_issn(xml)
          insert_item_number(xml)
          insert_funding_references(xml)
          insert_crossref_access_indicators(xml)
          insert_crossref_relations(xml)
          insert_archive_locations(xml)
          insert_doi_data(xml)
          insert_citation_list(xml)
        end
      end
    end

    def insert_posted_content(xml)
      posted_content = { "type" => "other", "language" => language ? language[0..1] : nil }.compact

      xml.posted_content(posted_content) do
        insert_group_title(xml)
        insert_crossref_contributors(xml)
        insert_crossref_titles(xml)
        insert_posted_date(xml)
        insert_institution(xml)
        insert_item_number(xml)
        insert_crossref_abstract(xml)
        insert_funding_references(xml)
        insert_crossref_access_indicators(xml)
        insert_crossref_relations(xml)
        insert_doi_data(xml)
        insert_citation_list(xml)
      end
    end

    def insert_group_title(xml)
      return xml if subjects.blank?

      xml.group_title(subjects.first["subject"])
    end

    def insert_crossref_contributors(xml)
      return xml if contributors.blank?

      con = Array.wrap(contributors).select { |c| c["contributorRoles"] == ["Author"] || c["contributorRoles"] == ["Editor"] }

      xml.contributors do
        Array.wrap(con).each_with_index do |contributor, index|
          contributor_role = contributor["contributorRoles"] == ["Author"] ? "author" : "editor"

          if contributor["type"] == "Organization" && contributor["name"].present?
            xml.organization(contributor["name"], "contributor_role" => contributor_role,
                                                  "sequence" => index.zero? ? "first" : "additional")
          elsif contributor["givenName"].present? || contributor["familyName"].present?
            xml.person_name("contributor_role" => contributor_role,
                            "sequence" => index.zero? ? "first" : "additional") do
              insert_crossref_person(xml, contributor)
            end
          elsif contributor["affiliation"].present?
            xml.anonymous("contributor_role" => contributor_role,
                          "sequence" => index.zero? ? "first" : "additional") do
              insert_crossref_anonymous(xml, contributor)
            end
          else
            xml.anonymous("contributor_role" => contributor_role,
                          "sequence" => index.zero? ? "first" : "additional")
          end
        end
      end
    end

    def insert_crossref_person(xml, contributor)
      xml.given_name(contributor["givenName"]) if contributor["givenName"].present?
      xml.surname(contributor["familyName"]) if contributor["familyName"].present?
      if contributor.dig("id") && URI.parse(contributor.dig("id")).host == "orcid.org"
        xml.ORCID(contributor.dig("id"))
      end
      if contributor["affiliation"].present?
        xml.affiliations do
          xml.institution do
            xml.institution_name(contributor.dig("affiliation", 0, "name")) if contributor.dig("affiliation", 0, "name").present?
            xml.institution_id(contributor.dig("affiliation", 0, "id"), "type" => "ror") if contributor.dig("affiliation", 0, "id").present?
          end
        end
      end
    end

    def insert_crossref_anonymous(xml, contributor)
      xml.affiliations do
        xml.institution do
          xml.institution_name(contributor.dig("affiliation", 0, "name")) if contributor.dig("affiliation", 0, "name").present?
          xml.institution_id(contributor.dig("affiliation", 0, "id"), "type" => "ror") if contributor.dig("affiliation", 0, "id").present?
        end
      end
    end

    def insert_crossref_titles(xml)
      xml.titles do
        Array.wrap(titles).each do |title|
          if title.is_a?(Hash)
            xml.title(title["title"])
          else
            xml.title(title)
          end
        end
      end
    end

    def insert_citation_list(xml)
      xml.citation_list do
        Array.wrap(references).each do |ref|
          xml.citation("key" => ref["key"]) do
            xml.journal_article(ref["journal_title"]) if ref["journal_title"].present?
            xml.author(ref["author"]) if ref["author"].present?
            xml.volume(ref["volume"]) if ref["volume"].present?
            xml.first_page(ref["first_page"]) if ref["first_page"].present?
            xml.cYear(ref["publicationYear"]) if ref["publicationYear"].present?
            xml.article_title(ref["title"]) if ref["title"].present?
            xml.doi(doi_from_url(ref["doi"])) if ref["doi"].present?
            xml.unstructured_citation(ref["url"]) if ref["url"].present?
          end
        end
      end
    end

    # def insert_publisher(xml)
    #   xml.publisher(publisher || container && container["title"])
    # end

    # def insert_publication_year(xml)
    #   xml.publicationYear(publication_year)
    # end

    # def insert_resource_type(xml)
    #   return xml unless types.is_a?(Hash) && (types["schemaOrg"].present? || types["resourceTypeGeneral"])

    #   xml.resourceType(types["resourceType"] || types["schemaOrg"],
    #     'resourceTypeGeneral' => types["resourceTypeGeneral"] || Metadata::SO_TO_DC_TRANSLATIONS[types["schemaOrg"]] || "Other")
    # end

    def insert_crossref_access_indicators(xml)
      return xml if license.blank?

      rights_uri = license["url"]

      xml.program("xmlns" => "http://www.crossref.org/AccessIndicators.xsd",
                  "name" => "AccessIndicators") do
        xml.license_ref(rights_uri, "applies_to" => "vor")
        xml.license_ref(rights_uri, "applies_to" => "tdm")
      end
    end

    def insert_crossref_relations(xml)
      return xml if related_identifiers.blank?

      xml.program("xmlns" => "http://www.crossref.org/relations.xsd",
                  "name" => "relations") do
        related_identifiers.each do |related_identifier|
          xml.related_item do
            identifier_type = validate_doi(related_identifier["id"]) ? "doi" : "uri"
            id = identifier_type == "doi" ? doi_from_url(related_identifier["id"]) : related_identifier["id"]
            attributes = {
              "relationship-type" => related_identifier["type"].camelize(:lower),
              "identifier-type" => identifier_type,
            }.compact

            xml.intra_work_relation(id, attributes)
          end
        end
      end
    end

    # def insert_dates(xml)
    #   return xml unless Array.wrap(dates).present?

    #   xml.dates do
    #     Array.wrap(dates).each do |date|
    #       attributes = { 'dateType' => date["dateType"] || "Issued", 'dateInformation' => date["dateInformation"] }.compact
    #       xml.date(date["date"], attributes)
    #     end
    #   end
    # end

    def insert_funding_references(xml)
      return xml if funding_references.blank?

      xml.program("xmlns" => "http://www.crossref.org/fundref.xsd",
                  "name" => "fundref") do
        funding_references.each do |funding_reference|
          xml.assertion("name" => "fundgroup") do
            xml.assertion(funding_reference["funderName"], "name" => "funder_name") do
              xml.assertion(funding_reference["funderIdentifier"], "name" => "funder_identifier")
            end
            xml.assertion(funding_reference["awardNumber"], "name" => "award_number")
          end
        end
      end
    end

    def insert_crossref_subjects(xml)
      return xml unless subjects.present?

      xml.subjects do
        subjects.each do |subject|
          if subject.is_a?(Hash)
            xml.subject(subject["subject"])
          else
            xml.subject(subject)
          end
        end
      end
    end

    # def insert_version(xml)
    #   return xml unless version_info.present?

    #   xml.version(version_info)
    # end

    def insert_crossref_language(xml)
      return xml unless language.present?

      xml.language(language)
    end

    def insert_crossref_publication_date(xml)
      return xml if date["registered"].blank?

      date_ = get_datetime_from_iso8601(date["registered"])

      xml.publication_date("media_type" => "online") do
        xml.month(date_.month) if date_.month.present?
        xml.day(date_.day) if date_.day.present?
        xml.year(date_.year) if date_.year.present?
      end
    end

    def insert_posted_date(xml)
      return xml if date["published"].blank?

      date_ = get_datetime_from_iso8601(date["published"])

      xml.posted_date do
        xml.month(date_.month) if date_.month.present?
        xml.day(date_.day) if date_.day.present?
        xml.year(date_.year) if date_.year.present?
      end
    end

    def insert_institution(xml)
      return xml if publisher.blank?

      xml.institution do
        xml.institution_name(publisher["name"])
      end
    end

    def insert_item_number(xml)
      return xml if alternate_identifiers.blank?

      alternate_identifiers.each do |alternate_identifier|
        attributes = {
          "item_number_type" => alternate_identifier["alternateIdentifierType"] ? alternate_identifier["alternateIdentifierType"].downcase : nil,
        }.compact

        # strip hyphen from UUIDs, as item_number can only be 32 characters long (UUIDv4 is 36 characters long)
        alternate_identifier["alternateIdentifier"] = alternate_identifier["alternateIdentifier"].gsub("-", "") if alternate_identifier["alternateIdentifierType"] == "UUID"

        xml.item_number(alternate_identifier["alternateIdentifier"], attributes)
      end
    end

    def insert_archive_locations(xml)
      return xml if archive_locations.blank?

      xml.archive_locations do
        archive_locations.each do |archive_location|
          xml.archive("name" => archive_location)
        end
      end
    end

    def insert_doi_data(xml)
      return xml if doi_from_url(id).blank? || url.blank?

      xml.doi_data do
        doi = doi_from_url(id).downcase
        xml.doi(doi)
        xml.resource(url)
        xml.collection("property" => "text-mining") do
          xml.item do
            xml.resource(url, "mime_type" => "text/html")
            if is_rogue_scholar_doi?(doi)
              Array.wrap(files).each do |file|
                xml.resource(file["url"], "mime_type" => file["mimeType"])
              end
            end
          end
        end
      end
    end

    def insert_crossref_license(xml)
      return xml unless license.present?

      xml.license do
        rights = license
        if rights.is_a?(Hash)
          r = rights
        else
          r = {}
          r["rights"] = rights
          r["rightsUri"] = normalize_id(rights)
        end

        attributes = {
          "rightsURI" => r["rightsUri"],
          "rightsIdentifier" => r["rightsIdentifier"],
          "rightsIdentifierScheme" => r["rightsIdentifierScheme"],
          "schemeURI" => r["schemeUri"],
          "xml:lang" => r["lang"],
        }.compact

        xml.rights(r["rights"], attributes)
      end
    end

    def insert_crossref_issn(xml)
      issn = if container.to_h.fetch("identifierType", nil) == "ISSN"
          container.to_h.fetch("identifier", nil)
        end

      return xml if issn.blank?

      xml.issn(issn)
    end

    def insert_crossref_abstract(xml)
      return xml if descriptions.blank?

      if descriptions.first.is_a?(Hash)
        d = descriptions.first
      else
        d = {}
        d["description"] = descriptions.first
      end

      xml.abstract("xmlns" => "http://www.ncbi.nlm.nih.gov/JATS1") do
        xml.p(d["description"])
      end
    end

    def crossref_root_attributes
      { 'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation': "http://www.crossref.org/schema/5.3.1 https://www.crossref.org/schemas/crossref5.3.1.xsd",
        xmlns: "http://www.crossref.org/schema/5.3.1",
        'xmlns:jats': "http://www.ncbi.nlm.nih.gov/JATS1",
        'xmlns:fr': "http://www.crossref.org/fundref.xsd",
        'xmlns:mml': "http://www.w3.org/1998/Math/MathML",
        version: "5.3.1" }
    end
  end
end
