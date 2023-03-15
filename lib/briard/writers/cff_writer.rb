# frozen_string_literal: true

module Briard
  module Writers
    module CffWriter
      def cff
        return nil unless valid? || show_errors

        # only use CFF for software
        return nil unless %w[Software Collection].include?(types['resourceTypeGeneral'])

        title = parse_attributes(titles, content: 'title', first: true)
        hsh = {
          'cff-version' => '1.2.0',
          'message' => "If you use #{title} in your work, please cite it using the following metadata",
          'doi' => normalize_doi(doi),
          'repository-code' => url,
          'title' => parse_attributes(titles, content: 'title', first: true),
          'authors' => write_cff_creators(creators),
          'abstract' => parse_attributes(descriptions, content: 'description', first: true),
          'version' => version_info,
          'keywords' => if subjects.present?
                          Array.wrap(subjects).map do |k|
                            parse_attributes(k, content: 'subject', first: true)
                          end
                        end,
          'date-released' => get_date(dates, 'Issued') || publication_year,
          'license' => Array.wrap(rights_list).map { |l| l['rightsIdentifier'] }.compact.unwrap,
          'references' => write_references(related_identifiers)
        }.compact
        hsh.to_yaml
      end

      def write_cff_creators(creators)
        Array.wrap(creators).map do |a|
          if a['givenName'].present? || a['nameIdentifiers'].present?
            { 'given-names' => a['givenName'],
              'family-names' => a['familyName'],
              'orcid' => parse_attributes(a['nameIdentifiers'], content: 'nameIdentifier',
                                                                first: true),
              'affiliation' => parse_attributes(a['affiliation'], content: 'name',
                                                                  first: true) }.compact
          else
            { 'name' => a['name'] }
          end
        end
      end

      def write_references(related_identifiers)
        return nil if related_identifiers.blank?

        { 'identifiers' =>
        Array.wrap(related_identifiers).map do |r|
          {
            'type' => r['relatedIdentifierType'].downcase,
            'value' => r['relatedIdentifierType'] == 'DOI' ? doi_from_url(r['relatedIdentifier']) : r['relatedIdentifier']
          }
        end }
      end
    end
  end
end
