# frozen_string_literal: true

module Commonmeta
  module Readers
    module RisReader
      def read_ris(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = ris_meta(string: string)

        ris_type = meta.fetch('TY', nil) || 'GEN'
        type = Commonmeta::Utils::RIS_TO_CM_TRANSLATIONS.fetch(ris_type, 'Other')

        id = normalize_doi(options[:doi] || meta.fetch('DO', nil))

        author = Array.wrap(meta.fetch('AU', nil)).map { |a| { 'name' => a } }
        date_parts = meta.fetch('PY', nil).to_s.split('/')
        created_date_parts = meta.fetch('Y1', nil).to_s.split('/')
        date = {}
        date['published'] = get_date_from_parts(*date_parts) if meta.fetch('PY', nil).present?
        date['created'] = get_date_from_parts(*created_date_parts) if meta.fetch('Y1', nil).present?

        container = if meta.fetch('T2', nil).present?
                      { 'type' => 'Journal',
                        'title' => meta.fetch('T2', nil),
                        'identifier' => meta.fetch('SN', nil),
                        'volume' => meta.fetch('VL', nil),
                        'issue' => meta.fetch('IS', nil),
                        'firstPage' => meta.fetch('SP', nil),
                        'lastPage' => meta.fetch('EP', nil) }.compact
                    end
        state = meta.fetch('DO', nil).present? || read_options.present? ? 'findable' : 'not_found'
        subjects = Array.wrap(meta.fetch('KW', nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        { 'id' => id,
          'type' => type,
          'url' => meta.fetch('UR', nil),
          'titles' => meta.fetch('T1', nil).present? ? [{ 'title' => meta.fetch('T1', nil) }] : nil,
          'creators' => get_authors(author),
          'publisher' => { 'name' => meta.fetch('PB', '(:unav)') },
          'container' => container,
          'date' => date,
          'descriptions' => if meta.fetch('AB', nil).present?
                              [{ 'description' => sanitize(meta.fetch('AB')),
                                 'descriptionType' => 'Abstract' }]
                            end,
          'subjects' => subjects,
          'language' => meta.fetch('LA', nil),
          'state' => state }.compact.merge(read_options)
      end

      def ris_meta(string: nil)
        h = Hash.new { |h, k| h[k] = [] }
        string.split("\n").each_with_object(h) do |line, _sum|
          k, v = line.split('-', 2)
          h[k.strip] << v.to_s.strip
        end.transform_values(&:unwrap).compact
      end
    end
  end
end
