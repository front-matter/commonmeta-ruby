# frozen_string_literal: true

module Commonmeta
  module Readers
    module CslReader
      def read_csl(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { "errors" => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? JSON.parse(string) : {}

        citeproc_type = meta.fetch("type", nil)
        type = Commonmeta::Utils::CSL_TO_CM_TRANSLATIONS.fetch(citeproc_type, "Other")

        creators = if meta.fetch("author", nil).present?
            get_authors(from_csl(Array.wrap(meta.fetch("author", nil))))
          else
            [{ "type" => "Organization", "name" => ":(unav)" }]
          end
        contributors = get_authors(from_csl(Array.wrap(meta.fetch("editor", nil))))

        date = {}
        d = get_date_from_date_parts(meta.fetch("issued", nil))
        date["published"] = d if Date.edtf(d).present?

        license = if meta.fetch("copyright", nil)
            hsh_to_spdx("rightsURI" => meta.fetch("copyright"))
          end
        container = if meta.fetch("container-title", nil).present?
            first_page = if meta.fetch("page", nil).present?
                meta.fetch("page").split("-").map(&:strip)[0]
              end
            last_page = if meta.fetch("page", nil).present?
                meta.fetch("page").split("-").map(&:strip)[1]
              end

            { "type" => "Periodical",
              "title" => meta.fetch("container-title", nil),
              "identifier" => meta.fetch("ISSN", nil),
              "identifierType" => meta.fetch("ISSN", nil).present? ? "ISSN" : nil,
              "volume" => meta.fetch("volume", nil),
              "issue" => meta.fetch("issue", nil),
              "firstPage" => first_page,
              "lastPage" => last_page }.compact
          end

        id = normalize_id(meta.fetch("id", nil) || meta.fetch("DOI", nil))

        state = id.present? || read_options.present? ? "findable" : "not_found"
        subjects = Array.wrap(meta.fetch("categories", nil)).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)

          sum
        end

        { "id" => id,
          "type" => type,
          "url" => normalize_id(meta.fetch("URL", nil)),
          "titles" => [{ "title" => meta.fetch("title", nil) }],
          "creators" => creators,
          "contributors" => contributors,
          "container" => container,
          "publisher" => meta.fetch("publisher", nil) ? { "name" => meta.fetch("publisher", nil) } : nil,
          "date" => date,
          "descriptions" => if meta.fetch("abstract", nil).present?
          [{ "description" => sanitize(meta.fetch("abstract")),
             "descriptionType" => "Abstract" }]
        else
          []
        end,
          "license" => license,
          "version" => meta.fetch("version", nil),
          "subjects" => subjects,
          "state" => state }.compact.merge(read_options)
      end
    end
  end
end
