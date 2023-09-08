# frozen_string_literal: true

module Commonmeta
  module Writers
    module CodemetaWriter
      def codemeta
        return nil unless valid? || show_errors
        
        authors = Array.wrap(contributors).select { |c| c['contributorRoles'] == ['Author'] }
        
        hsh = {
          '@context' => id.present? ? 'https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld' : nil,
          '@type' => Commonmeta::Utils::CM_TO_SO_TRANSLATIONS.fetch(type, 'SoftwareSourceCode'),
          '@id' => normalize_id(id),
          'identifier' => to_schema_org_identifiers(alternate_identifiers),
          'codeRepository' => url,
          'name' => parse_attributes(titles, content: 'title', first: true),
          'authors' => to_schema_org(authors),
          'description' => parse_attributes(descriptions, content: 'description', first: true),
          'version' => version,
          'tags' => if subjects.present?
                      Array.wrap(subjects).map do |k|
                        parse_attributes(k, content: 'subject', first: true)
                      end
                    end,
          'datePublished' => date['published'],
          'dateModified' => date['updated'],
          'publisher' => publisher['name'],
          'license' => license.to_h['id']
        }.compact
        JSON.pretty_generate hsh.presence
      end
    end
  end
end
