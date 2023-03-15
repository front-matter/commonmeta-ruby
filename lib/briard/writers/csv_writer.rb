# frozen_string_literal: true

module Briard
  module Writers
    module CsvWriter
      require 'csv'

      def csv
        return nil unless valid?

        bib = {
          doi: doi,
          url: url,
          registered: get_date(dates, 'Issued'),
          state: state,
          resource_type_general: types['resourceTypeGeneral'],
          resource_type: types['resourceType'],
          title: parse_attributes(titles, content: 'title', first: true),
          author: authors_as_string(creators),
          publisher: publisher,
          publication_year: publication_year
        }.values

        CSV.generate { |csv| csv << bib }
      end
    end
  end
end
