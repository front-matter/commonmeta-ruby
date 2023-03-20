# frozen_string_literal: true

module Commonmeta
  module Readers
    module CrossrefXmlReader
      # CrossRef types from https://api.crossref.org/types
      def get_crossref_xml(id: nil, **_options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        doi = doi_from_url(id)
        api_url = "https://api.crossref.org/works/#{doi}/transform/application/vnd.crossref.unixsd+xml"
        response = HTTP.get(api_url)
        return { 'string' => nil, 'state' => 'not_found' } unless response.status.success?

        { 'string' => response.body.to_s }
      end

      def read_crossref_xml(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        if string.present?
          # query contains information from outside metadata schema, e.g. publisher name
          query = Hash.from_xml(string).dig('crossref_result', 'query_result', 'body', 'query')
          meta = query.dig('doi_record', 'crossref', 'error').nil? ? query.dig('doi_record') : {}
        else
          meta = {}
          query = {}
        end

        # model should be one of book, conference, database, dissertation, journal, peer_review, posted_content,
        # report_paper, sa_component, standard
        model = meta['crossref'].to_h.keys.first

        resource_type = nil
        bibmeta = {}
        program_metadata = {}
        journal_metadata = nil
        journal_issue = {}
        journal_metadata = nil
        publisher = query.dig('crm_item', 0)
        publisher = nil unless publisher.is_a?(String)

        case model
        when 'book'
          book_metadata = meta.dig('crossref', 'book', 'book_metadata')
          book_series_metadata = meta.dig('crossref', 'book', 'book_series_metadata')
          book_set_metadata = meta.dig('crossref', 'book', 'book_set_metadata')
          bibmeta = meta.dig('crossref', 'book',
                             'content_item') || book_metadata || book_series_metadata || book_set_metadata
          resource_type = if bibmeta.fetch('component_type', nil)
                            "book-#{bibmeta.fetch('component_type')}"
                          else
                            'book'
                          end
          # publisher = if book_metadata.present?
          #               book_metadata.dig("publisher", "publisher_name")
          #             elsif book_series_metadata.present?
          #               book_series_metadata.dig("publisher", "publisher_name")
          #             end
        when 'conference'
          event_metadata = meta.dig('crossref', 'conference', 'event_metadata') || {}
          bibmeta = meta.dig('crossref', 'conference', 'conference_paper').to_h
        when 'journal'
          journal_metadata = meta.dig('crossref', 'journal', 'journal_metadata') || {}
          journal_issue = meta.dig('crossref', 'journal', 'journal_issue') || {}
          journal_article = meta.dig('crossref', 'journal', 'journal_article') || {}
          bibmeta = journal_article.presence || journal_issue.presence || journal_metadata
          program_metadata = bibmeta.dig('crossmark', 'custom_metadata',
                                         'program') || bibmeta['program']
          resource_type = if journal_article.present?
                            'journal_article'
                          elsif journal_issue.present?
                            'journal_issue'
                          else
                            'journal'
                          end
        when 'posted_content'
          bibmeta = meta.dig('crossref', 'posted_content').to_h
          publisher ||= bibmeta.dig('institution', 'institution_name')
        when 'sa_component'
          bibmeta = meta.dig('crossref', 'sa_component', 'component_list', 'component').to_h
          related_identifier = Array.wrap(query.to_h['crm_item']).find do |cr|
            cr['name'] == 'relation'
          end
          journal_metadata = { 'relatedIdentifier' => related_identifier.to_h.fetch('__content',
                                                                                    nil) }
        when 'database'
          bibmeta = meta.dig('crossref', 'database', 'dataset').to_h
          resource_type = 'dataset'
        when 'report_paper'
          bibmeta = meta.dig('crossref', 'report_paper', 'report_paper_metadata').to_h
          resource_type = 'report'
        when 'peer_review'
          bibmeta = meta.dig('crossref', 'peer_review')
        when 'dissertation'
          bibmeta = meta.dig('crossref', 'dissertation')
        end

        resource_type = (resource_type || model).to_s.underscore.camelcase.presence
        resource_type = resource_type.present? ? resource_type.underscore.camelcase : nil
        type = Commonmeta::Utils::CR_TO_CM_TRANSLATIONS.fetch(resource_type, 'Other')

        titles = if bibmeta['titles'].present?
                   Array.wrap(bibmeta['titles']).map do |r|
                     if r.blank? || (r['title'].blank? && r['original_language_title'].blank?)
                       nil
                     elsif r['title'].is_a?(String)
                       { 'title' => sanitize(r['title']) }
                     elsif r['original_language_title'].present?
                       { 'title' => sanitize(r.dig('original_language_title', '__content__')),
                         'lang' => r.dig('original_language_title', 'language') }
                     else
                       # TODO: handle titles with <i> and <b> tags
                       { 'title' => sanitize(r.dig('title', '__content__')) }.compact
                     end
                   end.compact
                 else
                   [{ 'title' => ':(unav)' }]
                 end

        date = {}
        date['published'] = crossref_date_published(bibmeta) # || Array.wrap(query.to_h["crm_item"]).find { |cr| cr["name"] == "created" }
        date['updated'] = parse_attributes(Array.wrap(query.to_h['crm_item']).find do |cr|
                                             cr['name'] == 'last-update'
                                           end)
        date['registered'] = Array.wrap(query.to_h['crm_item']).find do |cr|
          cr['name'] == 'deposit-timestamp'
        end
        if date['registered'].present?
          date['registered'] = get_datetime_from_time(parse_attributes(date['registered']))
        end

        # check that date is valid iso8601 date
        date['published'] = nil unless Date.edtf(date['published']).present?
        date['updated'] = nil unless Date.edtf(date['updated']).present?

        # TODO: fix timestamp. Until then, remove time as this is not always stable with Crossref (different server timezones)
        date['published'] = get_iso8601_date(date['published']) if date['published'].present?
        date['registered'] = get_iso8601_date(date['registered']) if date['registered'].present?
        date['updated'] = get_iso8601_date(date['updated']) if date['updated'].present?

        state = meta.present? || read_options.present? ? 'findable' : 'not_found'

        references = Array.wrap(crossref_references(bibmeta))

        container = if journal_metadata.present?
                      issn = normalize_issn(journal_metadata.to_h.fetch('issn', nil))

                      { 'type' => 'Journal',
                        'identifier' => issn,
                        'identifierType' => issn.present? ? 'ISSN' : nil,
                        'title' => parse_attributes(journal_metadata.to_h['full_title']),
                        'volume' => parse_attributes(journal_issue.dig('journal_volume', 'volume')),
                        'issue' => parse_attributes(journal_issue['issue']),
                        'firstPage' => bibmeta.dig('pages',
                                                   'first_page') || parse_attributes(journal_article.to_h.dig('publisher_item', 'item_number'),
                                                                                     first: true),
                        'lastPage' => bibmeta.dig('pages', 'last_page') }.compact

                    # By using book_metadata, we can account for where resource_type is `BookChapter` and not assume its a whole book
                    elsif book_metadata.present?
                      identifiers = crossref_alternate_identifiers(book_metadata)

                      {
                        'type' => 'Book',
                        'title' => book_metadata.dig('titles', 'title'),
                        'firstPage' => bibmeta.dig('pages', 'first_page'),
                        'lastPage' => bibmeta.dig('pages', 'last_page'),
                        'identifiers' => identifiers
                      }.compact
                    elsif book_series_metadata.to_h.fetch('series_metadata', nil).present?
                      issn = normalize_issn(book_series_metadata.dig('series_metadata', 'issn'))

                      { 'type' => 'Book Series',
                        'identifier' => issn,
                        'identifierType' => issn.present? ? 'ISSN' : nil,
                        'title' => book_series_metadata.dig('series_metadata', 'titles', 'title'),
                        'volume' => bibmeta.fetch('volume', nil) }.compact
                    end

        id = normalize_doi(options[:doi] || options[:id] || bibmeta.dig('doi_data', 'doi'))

        # Let sections override this in case of alternative metadata structures, such as book chapters, which
        # have their meta inside `content_item`, but the main book indentifers inside of `book_metadata`
        alternate_identifiers ||= crossref_alternate_identifiers(bibmeta)
        url = parse_attributes(bibmeta.dig('doi_data', 'resource'), first: true)
        url = normalize_url(url) if url.present?

        { 'id' => id,
          'type' => type,
          'url' => url,
          'titles' => titles,
          'alternate_identifiers' => alternate_identifiers,
          'creators' => crossref_people(bibmeta, 'author'),
          'contributors' => crossref_people(bibmeta, 'editor'),
          'funding_references' => crossref_funding_reference(program_metadata),
          'publisher' => { 'name' => publisher },
          'container' => container,
          'provider' => provider = options[:ra] || get_doi_ra(id) || 'Crossref',
          'references' => references,
          'date' => date.compact,
          'descriptions' => crossref_description(bibmeta),
          'license' => crossref_license(program_metadata),
          'version' => nil,
          'subjects' => nil,
          'language' => nil,
          'sizes' => nil,
          'state' => state }.compact.merge(read_options)
      end

      def crossref_alternate_identifiers(bibmeta)
        if bibmeta.dig('publisher_item', 'item_number').present?
          Array.wrap(bibmeta.dig('publisher_item', 'item_number')).map do |item|
            if item.is_a?(String)
              { 'alternateIdentifier' => item,
                'alternateIdentifierType' => 'Publisher ID' }
            else
              { 'alternateIdentifier' => item.fetch('__content__', nil),
                'alternateIdentifierType' => item.fetch('item_number_type', nil) || 'Publisher ID' }
            end
          end
        elsif parse_attributes(bibmeta.fetch('item_number', nil)).present?
          [{ 'alternateIdentifier' => parse_attributes(bibmeta.fetch('item_number', nil)),
             'alternateIdentifierType' => parse_attributes(bibmeta.dig('item_number',
                                                                       'item_number_type')) || 'Publisher ID' }]
        elsif parse_attributes(bibmeta.fetch('isbn', nil)).present?
          [{ 'alternateIdentifier' => parse_attributes(bibmeta.fetch('isbn', nil), first: true),
             'alternateIdentifierType' => 'ISBN' }]
        else
          []
        end
      end

      def crossref_description(bibmeta)
        abstract = Array.wrap(bibmeta['abstract']).map do |r|
          { 'descriptionType' => r.fetch('abstract_type', nil).present? ? 'Other' : 'Abstract',
            'description' => sanitize(parse_attributes(r, content: 'p'), first: true) }.compact
        end

        description = Array.wrap(bibmeta['description']).map do |r|
          { 'descriptionType' => 'Other', 'description' => sanitize(parse_attributes(r)) }.compact
        end

        (abstract + description)
      end

      def crossref_license(program_metadata)
        access_indicator = Array.wrap(program_metadata).find { |m| m['name'] == 'AccessIndicators' }
        return unless access_indicator.present?

        Array.wrap(access_indicator['license_ref']).reduce({}) do |sum, license|
          sum.merge!(hsh_to_spdx('rightsURI' => parse_attributes(license)))
        end
      end

      def crossref_people(bibmeta, contributor_role)
        person = bibmeta.dig('contributors', 'person_name') || bibmeta['person_name']
        organization = Array.wrap(bibmeta.dig('contributors', 'organization'))
        if contributor_role == 'author' && Array.wrap(person).select do |a|
          a['contributor_role'] == 'author'
        end.blank? && Array.wrap(organization).select do |a|
          a['contributor_role'] == 'author'
        end.blank?
          person = [{ 'name' => ':(unav)', 'contributor_role' => 'author' }]
        end

        (Array.wrap(person) + Array.wrap(organization)).select do |a|
          a['contributor_role'] == contributor_role
        end.map do |a|
          id = parse_attributes(a['ORCID']) ? normalize_orcid(parse_attributes(a['ORCID'])) : nil
          if a['surname'].present? || a['given_name'].present?
            given_name = parse_attributes(a['given_name']).presence
            family_name = parse_attributes(a['surname']).presence
            affiliation = Array.wrap(a['affiliation']).map do |a|
              if a.is_a?(Hash) && a.key?('__content__') && a['__content__'].strip.blank?
                nil
              elsif a.is_a?(Hash) && a.key?('__content__')
                { 'name' => a['__content__'] }
              elsif a.is_a?(Hash)
                a
              elsif a.strip.blank?
                nil
              elsif a.is_a?(String)
                { 'name' => a }
              end
            end.compact

            { 'type' => 'Person',
              'id' => id,
              'name' => if given_name || family_name
                          nil
                        else
                          [family_name, given_name].compact.join(', ')
                        end,
              'givenName' => given_name,
              'familyName' => family_name,
              'affiliation' => affiliation.presence,
              'contributorType' => contributor_role == 'editor' ? 'Editor' : nil }.compact
          else
            { 'type' => 'Organization',
              'name' => a['name'] || a['__content__'],
              'contributorType' => contributor_role == 'editor' ? 'Editor' : nil }.compact
          end
        end
      end

      def crossref_funding_reference(program_metadata)
        fundref = Array.wrap(program_metadata).find { |a| a['name'] == 'fundref' } || {}
        Array.wrap(fundref.fetch('assertion', [])).select do |a|
          a['name'] == 'fundgroup' && a['assertion'].present?
        end.map do |f|
          funder_identifier = nil
          funder_identifier_type = nil
          funder_name = nil
          award_title = nil
          award_number = nil
          award_uri = nil

          Array.wrap(f.fetch('assertion')).each do |a|
            case a.fetch('name')
            when 'award_number'
              award_number = a.fetch('__content__', nil)
              award_uri = a.fetch('awardURI', nil)
            when 'funder_name'
              funder_name = a.fetch('__content__', nil).to_s.squish.presence
              funder_identifier = validate_funder_doi(a.dig('assertion', '__content__'))
              funder_identifier_type = 'Crossref Funder ID' if funder_identifier.present?
            end
          end

          # funder_name is required in DataCite
          next unless funder_name.present?

          { 'funderIdentifier' => funder_identifier,
            'funderIdentifierType' => funder_identifier_type,
            'funderName' => funder_name,
            'awardTitle' => award_title,
            'awardNumber' => award_number,
            'awardUri' => award_uri }.compact
        end.compact
      end

      def crossref_date_published(bibmeta)
        pub_date = Array.wrap(bibmeta.fetch('publication_date', nil)).presence ||
                   Array.wrap(bibmeta.fetch('acceptance_date', nil))
        return unless pub_date.present?

        get_date_from_parts(pub_date.first['year'], pub_date.first['month'], pub_date.first['day'])
      end

      def crossref_references(bibmeta)
        refs = bibmeta.dig('citation_list', 'citation')
        Array.wrap(refs).map do |reference|
          return nil unless reference.present? || !reference.is_a?(Hash)

          doi = parse_attributes(reference.dig('doi'))

          {
            'key' => reference.dig('key'),
            'doi' => doi ? normalize_doi(doi) : nil,
            'creator' => reference.dig('author'),
            'title' => reference.dig('article_title'),
            'publisher' => reference.dig('publisher'),
            'publicationYear' => reference.dig('cYear'),
            'volume' => reference.dig('volume'),
            'issue' => reference.dig('issue'),
            'firstPage' => reference.dig('first_page'),
            'lastPage' => reference.dig('last_page'),
            'containerTitle' => reference.dig('journal_title'),
            'edition' => nil,
            'contributor' => nil,
            'unstructured' => doi.nil? ? reference.dig('unstructured') : nil
          }.compact
        end.unwrap
      end
    end
  end
end
