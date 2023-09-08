# frozen_string_literal: true

module Commonmeta
  module Writers
    module DataciteWriter
      def datacite
        resource_type_general = Commonmeta::Utils::CM_TO_DC_TRANSLATIONS.fetch(type, 'Other')
        types = { 'resourceTypeGeneral' => resource_type_general,
                  'resourceType' => type == resource_type_general ? nil : type,
                  'bibtex' => Commonmeta::Utils::CM_TO_BIB_TRANSLATIONS.fetch(type, 'misc'),
                  'citeproc' => Commonmeta::Utils::CM_TO_CSL_TRANSLATIONS.fetch(type, 'article'),
                  'ris' => Commonmeta::Utils::CM_TO_RIS_TRANSLATIONS.fetch(type, 'GEN'),
                  'schemaOrg' => Commonmeta::Utils::CM_TO_SO_TRANSLATIONS.fetch(type,
                                                                                'CreativeWork') }.compact

        dates = get_dates_from_date(date)
        rights_list = spdx_to_hsh(license)
        related_identifiers = Array.wrap(references).map { |r| datacite_reference(r) }

        hsh = {
          'id' => id,
          'doi' => doi_from_url(id),
          'url' => url,
          'types' => types,
          'creators' => Array.wrap(contributors).map { |c| datacite_contributor(c) },
          'titles' => titles,
          'publisher' => publisher.to_h['name'],
          'container' => container,
          'subjects' => subjects,
          'contributors' => Array.wrap(contributors).map { |c| datacite_contributor(c) },
          'dates' => dates,
          'language' => language,
          'alternate_identifiers' => alternate_identifiers,
          'sizes' => sizes,
          'formats' => formats,
          'version' => version,
          'rights_list' => rights_list,
          'descriptions' => descriptions,
          'geo_locations' => geo_locations,
          'funding_references' => funding_references,
          'related_identifiers' => related_identifiers,
          'schema_version' => schema_version,
          'provider_id' => provider_id,
          'client_id' => client_id,
          'agency' => provider,
          'state' => state
        }.compact

        JSON.pretty_generate hsh.transform_keys! { |key|
          key.camelcase(uppercase_first_letter = :lower)
        }
      end

      def datacite_contributor(contributor)
        type = contributor.fetch('type', nil)
        type += 'al' if type.present?

        if type == 'Personal'
          contributor['name'] = [contributor['familyName'], contributor['givenName']].join(', ')
        end
        contributor['nameIdentifiers'] = author_name_identifiers(contributor['id'])

        { 'name' => contributor.fetch('name', nil),
          'nameType' => type,
          'givenName' => contributor.fetch('givenName', nil),
          'familyName' => contributor.fetch('familyName', nil),
          'nameIdentifiers' => contributor.fetch('nameIdentifiers', nil).presence,
          'affiliation' => contributor.fetch('affiliation', nil).presence,
          'contributorType' => contributor.fetch('contributorType', nil) }.compact
      end

      def datacite_reference(reference)
        return nil unless reference.present? || !reference.is_a?(Hash)

        related_identifier = reference['doi'] || reference['url']

        return nil unless related_identifier.present?

        related_identifier_type = reference['doi'] ? 'DOI' : 'URL'

        { 'relatedIdentifier' => related_identifier,
          'relatedIdentifierType' => related_identifier_type,
          'relationType' => 'References' }.compact
      end
    end
  end
end
