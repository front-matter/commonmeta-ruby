# frozen_string_literal: true

module Briard
  module Writers
    module SchemaOrgWriter
      def schema_hsh
        { "@context" => "http://schema.org",
          "@type" => Briard::Utils::CM_TO_SO_TRANSLATIONS.fetch(type, "CreativeWork"),
          "@id" => id,
          "identifier" => to_schema_org_identifiers(alternate_identifiers),
          "url" => url,
          "additionalType" => nil,
          "name" => parse_attributes(titles, content: "title", first: true),
          "author" => to_schema_org(creators),
          "editor" => to_schema_org(contributors),
          "description" => parse_attributes(descriptions, content: "description", first: true),
          "license" => license.to_h["url"],
          "version" => version,
          "keywords" => subjects.present? ? Array.wrap(subjects).map { |k| parse_attributes(k, content: "subject", first: true) }.join(", ") : nil,
          "inLanguage" => language,
          "contentSize" => Array.wrap(sizes).unwrap,
          "encodingFormat" => Array.wrap(formats).unwrap,
          "dateCreated" => date["created"],
          "datePublished" => date['published'],
          "dateModified" => date['updated'],
          "pageStart" => container.to_h["firstPage"],
          "pageEnd" => container.to_h["lastPage"],
          "spatialCoverage" => to_schema_org_spatial_coverage(geo_locations),
          "citation" => references,
          "@reverse" => reverse.presence,
          "contentUrl" => Array.wrap(content_url).unwrap,
          "schemaVersion" => schema_version,
          "periodical" => type != "dataset" ? to_schema_org_container(container.to_h) : nil,
          "includedInDataCatalog" => type == "dataset" ? to_schema_org_container(container.to_h) : nil,
          "publisher" => publisher.present? ? { "@type" => "Organization", "name" => publisher } : nil,
          "funder" => to_schema_org_funder(funding_references),
          "provider" => provider.present? ? { "@type" => "Organization", "name" => provider } : nil
        }.compact.presence
      end

      def schema_org
        JSON.pretty_generate schema_hsh
      end
    end
  end
end
