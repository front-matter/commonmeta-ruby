# frozen_string_literal: true

module Bolognese
  module CrossrefUtils
    def crossref_xml
      @crossref_xml ||= Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.doi_records do
          insert_crossref_work(xml)
        end
      end.to_xml
    end

    def crossref_errors(xml: nil)
      filepath = File.expand_path("../../../resources/crossref/crossref5.3.1.xsd", __FILE__)
      schema = Nokogiri::XML::Schema(open(filepath))

      schema.validate(Nokogiri::XML(xml, nil, 'UTF-8')).map { |error| error.to_s }.unwrap
    rescue Nokogiri::XML::SyntaxError => e
      e.message
    end

    def insert_crossref_work(xml)
      insert_doi_record(xml)
    end

    def insert_doi_record(xml)
      return xml if doi.blank?

      date_published = get_date(dates, "Issued")
      timestamp = date_published.present? ? "#{date_published[0..9]} #{date_published[11..18]}" : nil

      xml.doi_record({ "owner" => doi.split("/").first, "timestamp" => timestamp }.compact) do
        xml.crossref do
          if types["resourceTypeGeneral"] == "JournalArticle"
            insert_journal(xml)
          elsif types["resourceTypeGeneral"] == "Preprint"
            insert_posted_content(xml)
          end
        end
      end
    end

    def insert_journal(xml)
      xml.journal do
        if language.present?
          xml.journal_metadata("language" => language) do
            xml.full_title(container["title"])
          end
        else
          xml.journal_metadata do
            xml.full_title(container["title"])
          end
        end
        xml.journal_article("publication_type" => "full_text") do
          insert_crossref_titles(xml)
          insert_crossref_creators(xml)
          insert_crossref_abstract(xml)
          insert_crossref_alternate_identifiers(xml)
          insert_crossref_access_indicators(xml)
          insert_doi_data(xml)
          insert_crossref_publication_date(xml)
          insert_citation_list(xml)
        end
      end
    end

    def insert_posted_content(xml)
      posted_content = { "type" => "other", "language" => language, "metadata_distribution_opts" => "any" }.compact

      xml.posted_content(posted_content) do
        insert_group_title(xml)
        insert_crossref_creators(xml)
        insert_crossref_titles(xml)
        insert_crossref_abstract(xml)
        insert_posted_date(xml)
        insert_crossref_alternate_identifiers(xml)
        insert_crossref_access_indicators(xml)
        insert_doi_data(xml)
        insert_citation_list(xml)
      end
    end

    def insert_group_title(xml)
      return xml if subjects.blank?

      xml.group_title(subjects.first["subject"].titleize)
    end

    def insert_crossref_creators(xml)
      xml.contributors do
        Array.wrap(creators).each_with_index do |au, index|
          xml.person_name("contributor_role" => "author", "sequence" => index == 0 ? "first" : "additional") do
            insert_crossref_person(xml, au, "author")
          end
        end
      end
    end

    def insert_crossref_person(xml, person, type)
      person_name = person["familyName"].present? ? [person["familyName"], person["givenName"]].compact.join(", ") : person["name"]
      xml.given_name(person["givenName"]) if person["givenName"].present?
      xml.surname(person["familyName"]) if person["familyName"].present?
      if person.dig("nameIdentifiers", 0, "nameIdentifierScheme") == "ORCID"
        xml.ORCID(person.dig("nameIdentifiers", 0, "nameIdentifier")) 
      end
      Array.wrap(person["affiliation"]).each do |affiliation|
        attributes = { "affiliationIdentifier" => affiliation["affiliationIdentifier"], "affiliationIdentifierScheme" => affiliation["affiliationIdentifierScheme"], "schemeURI" => affiliation["schemeUri"] }.compact
        xml.affiliation(affiliation["name"], attributes)
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
      # filter out references
      references = related_identifiers.find_all { |ri| ri["relationType"] == "References" }
      return xml if references.blank?

      xml.citation_list do
        references.each do |ref|
          xml.citation do
            xml.doi(ref["relatedIdentifier"])
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

    def insert_crossref_alternate_identifiers(xml)
      alternate_identifier = Array.wrap(identifiers).select { |r| r["identifierType"] != "DOI" }.first
      return xml if alternate_identifier.blank?

      xml.item_number(alternate_identifier["identifier"], "item_number_type" => alternate_identifier["identifierType"])
    end

    def insert_crossref_access_indicators(xml)
      return xml if rights_list.blank?
      rights_uri = Array.wrap(rights_list).map { |l| l["rightsUri"] }.first

      xml.program("xmlns:ai" => "http://www.crossref.org/AccessIndicators.xsd", "name" => "AccessIndicators") do
        xml.license_ref(rights_uri, "applies_to" => "vor")
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

    # def insert_funding_references(xml)
    #   return xml unless Array.wrap(funding_references).present?

    #   xml.fundingReferences do
    #     Array.wrap(funding_references).each do |funding_reference|
    #       xml.fundingReference do
    #         xml.funderName(funding_reference["funderName"])
    #         xml.funderIdentifier(funding_reference["funderIdentifier"], { "funderIdentifierType" => funding_reference["funderIdentifierType"] }.compact) if funding_reference["funderIdentifier"].present?
    #         xml.awardNumber(funding_reference["awardNumber"], { "awardURI" => funding_reference["awardUri"] }.compact) if funding_reference["awardNumber"].present? || funding_reference["awardUri"].present?
    #         xml.awardTitle(funding_reference["awardTitle"]) if funding_reference["awardTitle"].present?
    #       end
    #     end
    #   end
    # end

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
      return xml if date_registered.blank?

      date = get_datetime_from_iso8601(date_registered)
      
      xml.publication_date("media_type" => "online") do
        xml.month(date.month) if date.month.present?
        xml.day(date.day) if date.day.present?
        xml.year(date.year) if date.year.present?
      end
    end

    def insert_posted_date(xml)
      return xml if date_registered.blank?

      date = get_datetime_from_iso8601(date_registered)

      xml.posted_date do
        xml.month(date.month) if date.month.present?
        xml.day(date.day) if date.day.present?
        xml.year(date.year) if date.year.present?
      end
    end

    def insert_doi_data(xml)
      return xml if doi.blank? || url.blank?

      xml.doi_data do
        xml.doi(doi)
        xml.resource(url)
      end
    end

    def insert_crossref_rights_list(xml)
      return xml unless rights_list.present?

      xml.rightsList do
        Array.wrap(rights_list).each do |rights|
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
            "xml:lang" => r["lang"]
          }.compact

          xml.rights(r["rights"], attributes)
        end
      end
    end

    def insert_crossref_abstract(xml)
      return xml if descriptions.blank?

      if descriptions.first.is_a?(Hash)
        d = descriptions.first
      else
        d = {}
        d["description"] = descriptions.first
      end

      xml.abstract do
        xml.p(d["description"])
      end
    end
  end
end
