# frozen_string_literal: true

module Commonmeta
  module Readers
    module BibtexReader
      def read_bibtex(string: nil, **options)
        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? BibTeX.parse(string).first : OpenStruct.new

        bibtex_type = meta.try(:type).to_s
        type = Commonmeta::Utils::BIB_TO_CM_TRANSLATIONS.fetch(bibtex_type, "Other")

        doi = meta.try(:doi).to_s.presence || options[:doi]

        creators = Array(meta.try(:author)).map do |a|
          { "type" => "Person",
            "givenName" => a.first,
            "familyName" => a.last }.compact
        end

        container = if meta.try(:journal).present?
            first_page = meta.try(:pages).present? ? meta.try(:pages).split("-").map(&:strip)[0] : nil
            last_page = meta.try(:pages).present? ? meta.try(:pages).split("-").map(&:strip)[1] : nil

            { "type" => "Journal",
              "title" => meta.journal.to_s,
              "identifier" => meta.try(:issn).to_s.presence,
              "identifierType" => meta.try(:issn).present? ? "ISSN" : nil,
              "volume" => meta.try(:volume).to_s.presence,
              "firstPage" => first_page,
              "lastPage" => last_page }.compact
          end

        state = meta.try(:doi).to_s.present? || read_options.present? ? "findable" : "not_found"

        date = {}
        date["published"] = meta.try(:date).present? && Date.edtf(meta.date.to_s).present? ? meta.date.to_s : nil?

        license = meta.try(:copyright).present? ? hsh_to_spdx("rightsURI" => meta[:copyright]) : nil

        { "id" => normalize_doi(doi),
          "type" => type,
          "url" => meta.try(:url).to_s.presence,
          "titles" => meta.try(:title).present? ? [{ "title" => meta.try(:title).to_s }] : [],
          "creators" => creators,
          "container" => container,
          "publisher" => meta.try(:publisher).to_s ? { "name" => meta.publisher.to_s } : nil,
          "date" => date,
          "descriptions" => if meta.try(:abstract).present?
          [{
            "description" => meta.try(:abstract) && sanitize(meta.abstract.to_s).presence, "descriptionType" => "Abstract",
          }]
        else
          []
        end,
          "license" => license,
          "state" => state }.merge(read_options)
      end
    end
  end
end
