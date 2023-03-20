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
          'references' => { 'identifiers' => Array.wrap(references).map do |r|
                                               write_cff_reference(r)
                                             end }
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
        return nil if reference.blank?

        url = reference['url']
        doi = reference['doi']
        value = doi.present? ? doi_from_url(doi) : url
        type = doi.present? ? 'doi' : 'url'

        { 'type' => type, 'value' => value }.compact
      end
    end
  end
end
