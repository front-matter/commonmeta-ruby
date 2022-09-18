# frozen_string_literal: true

module Briard
  module Writers
    module BibtexWriter
      def bibtex
        return nil unless valid?

        pages = if container.to_h['firstPage'].present?
                  [container['firstPage'], container['lastPage']].compact.join('-')
                end

        bib = {
          bibtex_type: types['bibtex'].presence || 'misc',
          bibtex_key: normalize_doi(doi),
          doi: doi,
          url: url,
          author: authors_as_string(creators),
          keywords: if subjects.present?
                      Array.wrap(subjects).map do |k|
                        parse_attributes(k, content: 'subject', first: true)
                      end.join(', ')
                    end,
          language: language,
          title: parse_attributes(titles, content: 'title', first: true),
          journal: container && container['title'],
          volume: container.to_h['volume'],
          issue: container.to_h['issue'],
          pages: pages,
          publisher: publisher,
          year: publication_year,
          copyright: Array.wrap(rights_list).map { |l| l['rights'] }.first
        }.compact
        BibTeX::Entry.new(bib).to_s
      end
    end
  end
end
