# frozen_string_literal: true

module Briard
  module Writers
    module CffWriter
      def cff
        return nil unless valid? || show_errors

        # only use CFF for software
        return nil unless types["resourceTypeGeneral"] == "Software"
        
        hsh = {
          "doi" => normalize_doi(doi),
          "repository-code" => url,
          "title" => parse_attributes(titles, content: "title", first: true),
          "authors" => creators,
          "abstract" => parse_attributes(descriptions, content: "description", first: true),
          "version" => version_info,
          "keywords" => subjects.present? ? Array.wrap(subjects).map { |k| parse_attributes(k, content: "subject", first: true) } : nil,
          "date-released" => get_date(dates, "Issued") || publication_year,
          "license" => Array.wrap(rights_list).map { |l| l["rightsUri"] }.compact.unwrap,
        }.compact
        hsh.to_yaml
      end
    end
  end
end
