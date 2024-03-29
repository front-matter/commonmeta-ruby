# frozen_string_literal: true

module Commonmeta
  module Writers
    module CitationWriter
      def citation
        cp = CiteProc::Processor.new(style: style, locale: locale, format: 'html')
        cp.import Array.wrap(csl_hsh)
        bibliography = cp.render :bibliography, id: normalize_doi(id)
        bibliography.first
      end
    end
  end
end
