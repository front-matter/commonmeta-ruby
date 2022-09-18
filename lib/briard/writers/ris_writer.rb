# frozen_string_literal: true

module Briard
  module Writers
    module RisWriter
      def ris
        {
          'TY' => types['ris'],
          'T1' => parse_attributes(titles, content: 'title', first: true),
          'T2' => container && container['title'],
          'AU' => to_ris(creators),
          'DO' => doi,
          'UR' => url,
          'AB' => parse_attributes(descriptions, content: 'description', first: true),
          'KW' => Array.wrap(subjects).map do |k|
                    parse_attributes(k, content: 'subject', first: true)
                  end.presence,
          'PY' => publication_year,
          'PB' => publisher,
          'LA' => language,
          'VL' => container.to_h['volume'],
          'IS' => container.to_h['issue'],
          'SP' => container.to_h['firstPage'],
          'EP' => container.to_h['lastPage'],
          'SN' => Array.wrap(related_identifiers).find do |ri|
                    ri['relationType'] == 'IsPartOf'
                  end.to_h.fetch('relatedIdentifier', nil),
          'ER' => ''
        }.compact.map do |k, v|
          if v.is_a?(Array)
            v.map do |vi|
              "#{k}  - #{vi}"
            end.join("\r\n")
          else
            "#{k}  - #{v}"
          end
        end.join("\r\n")
      end
    end
  end
end
