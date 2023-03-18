# frozen_string_literal: true

module Commonmeta
  module Writers
    module BibtexWriter
      def bibtex
        pages = if container.to_h['firstPage'].present?
                  [container['firstPage'], container['lastPage']].compact.join('-')
                end

        bib = {
          bibtex_type: Commonmeta::Utils::CM_TO_BIB_TRANSLATIONS.fetch(type, 'misc'),
          bibtex_key: normalize_id(id),
          doi: doi_from_url(id),
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
          publisher: publisher.to_h['name'],
          year: date.to_h['published'] && date['published'].split('-').first,
          copyright: license.to_h['id']
        }.compact
        BibTeX::Entry.new(bib).to_s
      end
    end
  end
end
