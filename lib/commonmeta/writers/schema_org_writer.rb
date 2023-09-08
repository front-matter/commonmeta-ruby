# frozen_string_literal: true

module Commonmeta
  module Writers
    module SchemaOrgWriter 
      def schema_hsh
        authors = contributors.select { |c| c['contributorRoles'] == ['Author'] }
        editors = contributors.select { |c| c['contributorRoles'] == ['Editor'] }

        { '@context' => 'http://schema.org',
          '@type' => Commonmeta::Utils::CM_TO_SO_TRANSLATIONS.fetch(type, 'CreativeWork'),
          '@id' => id,
          'identifier' => to_schema_org_identifiers(alternate_identifiers),
          'url' => url,
          'additionalType' => additional_type,
          'name' => parse_attributes(titles, content: 'title', first: true),
          'author' => to_schema_org(authors),
          'editor' => to_schema_org(editors),
          'description' => parse_attributes(descriptions, content: 'description', first: true),
          'license' => license.to_h['url'],
          'version' => version,
          'keywords' => if subjects.present?
                          Array.wrap(subjects).map do |k|
                            parse_attributes(k, content: 'subject', first: true)
                          end.join(', ').capitalize
                        end,
          'inLanguage' => language,
          'contentSize' => Array.wrap(sizes).unwrap,
          'encodingFormat' => Array.wrap(formats).unwrap,
          'dateCreated' => date['created'],
          'datePublished' => date['published'],
          'dateModified' => date['updated'],
          'pageStart' => container.to_h['firstPage'],
          'pageEnd' => container.to_h['lastPage'],
          'spatialCoverage' => to_schema_org_spatial_coverage(geo_locations),
          'citation' => Array.wrap(references).map { |r| to_schema_org_citation(r) },
          '@reverse' => reverse.presence,
          'contentUrl' => Array.wrap(content_url).unwrap,
          'schemaVersion' => schema_version,
          'periodical' => if type == 'Dataset'
                            nil
                          else
                            to_schema_org_container(container.to_h, type: 'Periodical')
                          end,
          'includedInDataCatalog' => if type == 'Dataset'
                                       to_schema_org_container(container.to_h, type: 'DataCatalog')
                                     end,
          'publisher' => if publisher.present?
                           { '@type' => 'Organization',
                             'name' => publisher['name'] }
                         end,
          'funder' => to_schema_org_funder(funding_references),
          'provider' => if provider.present?
                          { '@type' => 'Organization',
                            'name' => provider }
                        end }.compact.presence
      end

      def schema_org
        JSON.pretty_generate schema_hsh
      end
    end
  end
end
