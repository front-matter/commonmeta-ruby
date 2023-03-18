# frozen_string_literal: true

module Commonmeta
  module Writers
    module CffWriter
      def cff
        # return nil unless valid? || show_errors

        # only use CFF for software
        return nil unless %w[Software Collection].include?(type)

        title = parse_attributes(titles, content: 'title', first: true)

        hsh = {
          'cff-version' => '1.2.0',
          'message' => "If you use #{title} in your research, please cite it using the following metadata",
          'doi' => normalize_doi(id),
          'repository-code' => url,
          'title' => title,
          'authors' => write_cff_creators(creators),
          'abstract' => parse_attributes(descriptions, content: 'description', first: true),
          'version' => version,
          'keywords' => if subjects.present?
                          Array.wrap(subjects).map do |k|
                            parse_attributes(k, content: 'subject', first: true)
                          end
                        end,
          'date-released' => date['published'],
          'license' => license.to_h['id'],
          'references' => Array.wrap(references).map { |r| write_cff_reference(r) }
        }.compact
        hsh.to_yaml
      end

      def write_cff_creators(creators)
        Array.wrap(creators).map do |a|
          if a['givenName'].present? || a['id'].present?
            { 'given-names' => a['givenName'],
              'family-names' => a['familyName'],
              'orcid' => a['id'],
              'affiliation' => parse_attributes(a['affiliation'], content: 'name',
                                                                  first: true) }.compact
          else
            { 'name' => a['name'] }
          end
        end
      end

      def write_cff_reference(reference)
        puts reference
        return nil if reference.blank?

        { 'identifiers' =>
          {
            'type' => reference['relatedIdentifierType'].downcase,
            'value' => rrefence['relatedIdentifierType'] == 'DOI' ? doi_from_url(reference['relatedIdentifier']) : reference['relatedIdentifier']
          }
        }.compact
      end
    end
  end
end
