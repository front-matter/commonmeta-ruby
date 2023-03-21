# frozen_string_literal: true

module Commonmeta
  module CrossrefUtils
    # To configure the writing of Crossref metadata, use environmental
    # variables CROSSREF_DEPOSITOR_NAME, CROSSREF_DEPOSITOR_EMAIL and CROSSREF_REGISTRANT,
    # e.g. in a .env file
    def write_crossref_xml
      @crossref_xml ||= Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.doi_batch(crossref_root_attributes) do
          xml.head do
            # we use a uuid as batch_id
            xml.doi_batch_id(SecureRandom.uuid)
            xml.timestamp(Time.now.utc.strftime('%Y%m%d%H%M%S'))
            xml.depositor do
              xml.depositor_name(ENV.fetch('CROSSREF_DEPOSITOR_NAME', nil))
              xml.email_address(ENV.fetch('CROSSREF_DEPOSITOR_EMAIL', nil))
            end
            xml.registrant(ENV.fetch('CROSSREF_REGISTRANT', nil))
          end
          xml.body do
            insert_crossref_work(xml)
          end
        end
      end.to_xml
    end

    def crossref_errors(xml: nil)
      filepath = File.expand_path('../../resources/crossref/crossref5.3.1.xsd', __dir__)
      File.open(filepath, 'r') do |f|
        schema = Nokogiri::XML::Schema(f)
      end

      schema.validate(Nokogiri::XML(xml, nil, 'UTF-8')).map(&:to_s).unwrap
    rescue Nokogiri::XML::SyntaxError => e
      e.message
    end

    def insert_crossref_work(xml)
      return xml if doi_from_url(id).blank?

      case type
      when 'JournalArticle'
        insert_journal(xml)
      when 'Article'
        insert_posted_content(xml)
      end
    end

    def insert_journal(xml)
      xml.journal do
        if language.present?
          xml.journal_metadata('language' => language[0..1]) do
            xml.full_title(container['title'])
          end
        else
          xml.journal_metadata do
            xml.full_title(container['title'])
          end
        end
        xml.journal_article('publication_type' => 'full_text') do
          insert_crossref_titles(xml)
          insert_crossref_creators(xml)
          insert_crossref_publication_date(xml)
          insert_crossref_abstract(xml)
          insert_crossref_issn(xml)
          insert_crossref_alternate_identifiers(xml)
          insert_crossref_access_indicators(xml)
          insert_doi_data(xml)
          insert_citation_list(xml)
        end
      end
    end

    def insert_posted_content(xml)
      posted_content = { 'type' => 'other', 'language' => language ? language[0..1] : nil }.compact

      xml.posted_content(posted_content) do
        insert_group_title(xml)
        insert_crossref_creators(xml)
        insert_crossref_titles(xml)
        insert_posted_date(xml)
        insert_institution(xml)
        insert_crossref_abstract(xml)
        insert_crossref_alternate_identifiers(xml)
        insert_crossref_access_indicators(xml)
        insert_doi_data(xml)
        insert_citation_list(xml)
      end
    end

    def insert_group_title(xml)
      return xml if subjects.blank?

      xml.group_title(subjects.first['subject'].titleize)
    end

    def insert_crossref_creators(xml)
      xml.contributors do
        Array.wrap(creators).each_with_index do |person, index|
          xml.person_name('contributor_role' => 'author',
                          'sequence' => index.zero? ? 'first' : 'additional') do
            insert_crossref_person(xml, person)
          end
        end
      end
    end

    def insert_crossref_person(xml, person)
      xml.given_name(person['givenName']) if person['givenName'].present?
      xml.surname(person['familyName']) if person['familyName'].present?
      if person.dig('id') && URI.parse(person.dig('id')).host == 'orcid.org'
        xml.ORCID(person.dig('id'))
      end
      Array.wrap(person['affiliation']).each do |affiliation|
        attributes = { 'affiliationIdentifier' => affiliation['affiliationIdentifier'],
                       'affiliationIdentifierScheme' => affiliation['affiliationIdentifierScheme'], 'schemeURI' => affiliation['schemeUri'] }.compact
        xml.affiliation(affiliation['name'], attributes)
      end
    end

    def insert_crossref_titles(xml)
      xml.titles do
        Array.wrap(titles).each do |title|
          if title.is_a?(Hash)
            xml.title(title['title'])
          else
            xml.title(title)
          end
        end
      end
    end

    def insert_citation_list(xml)
      xml.citation_list do
        references.each do |ref|
          xml.citation('key' => ref['key']) do
            xml.journal_article(ref['journal_title'])
            xml.author(ref['author'])
            xml.volume(ref['volume'])
            xml.first_page(ref['first_page'])
            xml.cYear(ref['cYear'])
            xml.article_title(ref['article_title'])
            xml.doi(ref['doi']) if ref['doi'].present?
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
      alternate_identifier = Array.wrap(alternate_identifiers).reject do |r|
        %w[DOI, URL].include?(r['alternate_identifier_type'])
      end.first
      return xml if alternate_identifier.blank?

      xml.item_number(alternate_identifier['alternateIdentifier'],
                      'item_number_type' => alternate_identifier['alternateIdentifierType'])
    end

    def insert_crossref_access_indicators(xml)
      return xml if license.blank?

      rights_uri = license['url']

      xml.program('xmlns' => 'http://www.crossref.org/AccessIndicators.xsd',
                  'name' => 'AccessIndicators') do
        xml.license_ref(rights_uri, 'applies_to' => 'vor')
        xml.license_ref(rights_uri, 'applies_to' => 'tdm')
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
            xml.subject(subject['subject'])
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
      return xml if date['registered'].blank?

      date_ = get_datetime_from_iso8601(date['registered'])

      xml.publication_date('media_type' => 'online') do
        xml.month(date_.month) if date_.month.present?
        xml.day(date_.day) if date_.day.present?
        xml.year(date_.year) if date_.year.present?
      end
    end

    def insert_posted_date(xml)
      return xml if date['published'].blank?

      date_ = get_datetime_from_iso8601(date['published'])

      xml.posted_date do
        xml.month(date_.month) if date_.month.present?
        xml.day(date_.day) if date_.day.present?
        xml.year(date_.year) if date_.year.present?
      end
    end

    def insert_institution(xml)
      return xml if publisher.blank?

      xml.institution do
        xml.institution_name(publisher['name'])
      end
    end

    def insert_doi_data(xml)
      return xml if doi_from_url(id).blank? || url.blank?

      xml.doi_data do
        xml.doi(doi_from_url(id).downcase)
        xml.resource(url)
        xml.collection('property' => 'text-mining') do
          xml.item do
            xml.resource(url, 'mime_type' => 'text/html')
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
          r['rights'] = rights
          r['rightsUri'] = normalize_id(rights)
        end

        attributes = {
          'rightsURI' => r['rightsUri'],
          'rightsIdentifier' => r['rightsIdentifier'],
          'rightsIdentifierScheme' => r['rightsIdentifierScheme'],
          'schemeURI' => r['schemeUri'],
          'xml:lang' => r['lang']
        }.compact

        xml.rights(r['rights'], attributes)
      end
    end

    def insert_crossref_issn(xml)
      issn = if container.to_h.fetch('identifierType', nil) == 'ISSN'
               container.to_h.fetch('identifier', nil)
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
        d['description'] = descriptions.first
      end

      xml.abstract('xmlns' => 'http://www.ncbi.nlm.nih.gov/JATS1') do
        xml.p(d['description'])
      end
    end

    def crossref_root_attributes
      { 'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation': 'http://www.crossref.org/schema/5.3.1 https://www.crossref.org/schemas/crossref5.3.1.xsd',
        xmlns: 'http://www.crossref.org/schema/5.3.1',
        'xmlns:jats': 'http://www.ncbi.nlm.nih.gov/JATS1',
        'xmlns:fr': 'http://www.crossref.org/fundref.xsd',
        'xmlns:mml': 'http://www.w3.org/1998/Math/MathML',
        version: '5.3.1' }
    end
  end
end
