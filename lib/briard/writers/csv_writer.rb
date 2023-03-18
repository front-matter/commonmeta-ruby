# frozen_string_literal: true

module Briard
  module Writers
    module CsvWriter
      require 'csv'

      def csv
        return nil unless valid?

        bib = {
          doi: doi_from_url(id),
          url: url,
          registered: date['published'],
          state: state,
          type: Briard::Utils::CM_TO_BIB_TRANSLATIONS.fetch(type, "misc"),
          title: parse_attributes(titles, content: 'title', first: true),
          author: authors_as_string(creators),
          publisher: publisher['name'],
        }.values

        CSV.generate { |csv| csv << bib }
      end
    end
  end
end
