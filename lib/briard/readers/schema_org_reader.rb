# frozen_string_literal: true

module Briard
  module Readers
    module SchemaOrgReader
      SO_TO_DC_RELATION_TYPES = {
        "citation" => "References",
        "isBasedOn" => "IsSupplementedBy",
        "sameAs" => "IsIdenticalTo",
        "isPartOf" => "IsPartOf",
        "hasPart" => "HasPart",
        "isPredecessor" => "IsPreviousVersionOf",
        "isSuccessor" => "IsNewVersionOf",
      }.freeze

      SO_TO_DC_REVERSE_RELATION_TYPES = {
        "citation" => "IsReferencedBy",
        "isBasedOn" => "IsSupplementTo",
        "sameAs" => "IsIdenticalTo",
        "isPartOf" => "HasPart",
        "hasPart" => "IsPartOf",
        "isPredecessor" => "IsNewVersionOf",
        "isSuccessor" => "IsPreviousVersionOf",
      }.freeze

      def get_schema_org(id: nil, **_options)
        return { "string" => nil, "state" => "not_found" } unless id.present?

        url = normalize_id(id)
        response = Maremma.get(url, raw: true)

        # some responses are returned as a hash
        if response.body["data"].is_a?(Hash)
          string = response.body.dig("data", "html", "head", "script", 1, "__content__")
        else
          doc = Nokogiri::HTML(response.body.fetch("data", nil), nil, "UTF-8")

          # workaround for xhtml documents
          nodeset = doc.at("script[type='application/ld+json']")
          hsh = JSON.parse(nodeset || "{}")

          # workaround for doi as canonical_url but not included with schema.org
          link = doc.css("link[rel='canonical']")
          hsh["@id"] = link[0]["href"] if link.present?

          # workaround if license not included with schema.org
          license = doc.at("meta[name='dc.rights']")
          hsh["license"] = license["content"] if license.present?

          # workaround for html language attribute if no language is set via schema.org
          lang = doc.at("meta[name='dc.language']") || doc.at("meta[name='citation_language']")
          lang = lang["content"] if lang.present?
          lang = doc.at("html")["lang"] if lang.blank?
          hsh["inLanguage"] = lang if hsh["inLanguage"].blank?

          # workaround if issn not included with schema.org
          name = doc.at("meta[property='og:site_name']")
          issn = doc.at("meta[name='citation_issn']")
          hsh["isPartOf"] = { "name" => name ? name["content"] : nil,
                              "issn" => issn ? issn["content"] : nil }.compact

          # workaround if not all authors are included with schema.org (e.g. in Ghost metadata)
          authors = doc.css("meta[name='citation_author']").map do |author|
            { "@type" => "Person", "name" => author["content"] }
          end

          hsh["author"] = hsh["creator"] if hsh["author"].blank? && hsh["creator"].present?
          hsh["author"] = authors if authors.length > Array.wrap(hsh["author"]).length

          # workaround if publisher not included with schema.org (e.g. Zenodo)
          if hsh["publisher"].blank?
            publisher = doc.at("meta[property='og:site_name']")
            publisher = publisher["content"] if publisher.present?
            hsh["publisher"] = { "name" => publisher }
          end

          string = hsh.to_json if hsh.present?
        end

        { "string" => string }
      end

      def read_schema_org(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { "errors" => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))

        meta = string.present? ? Maremma.from_json(string) : {}

        identifiers = Array.wrap(meta.fetch("identifier", nil)).map do |r|
          r = normalize_id(r) if r.is_a?(String)
          if r.is_a?(String) && URI(r).host != "doi.org"
            { "identifierType" => "URL", "identifier" => r }
          elsif r.is_a?(Hash)
            { "identifierType" => get_identifier_type(r["propertyID"]), "identifier" => r["value"] }
          end
        end.compact.uniq

        id = options[:doi]
        id = meta.fetch("@id", nil) if id.blank? && URI(meta.fetch("@id", "")).host == "doi.org"
        id = meta.fetch("identifier", nil) if id.blank?
        id = normalize_id(id)

        schema_org = meta.fetch("@type", nil) && meta.fetch("@type").camelcase
        resource_type_general = Briard::Utils::SO_TO_DC_TRANSLATIONS[schema_org]
        types = {
          "resourceTypeGeneral" => resource_type_general,
          "resourceType" => meta.fetch("additionalType", nil),
          "schemaOrg" => schema_org,
          "citeproc" => Briard::Utils::SO_TO_CP_TRANSLATIONS[schema_org] || "article-journal",
          "bibtex" => Briard::Utils::SO_TO_BIB_TRANSLATIONS[schema_org] || "misc",
          "ris" => Briard::Utils::SO_TO_RIS_TRANSLATIONS[resource_type_general.to_s.dasherize] || "GEN",
        }.compact
        authors = meta.fetch("author", nil) || meta.fetch("creator", nil)
        # Authors should be an object, if it's just a plain string don't try and parse it.
        unless authors.is_a?(String)
          creators = get_authors(from_schema_org_creators(Array.wrap(authors)))
        end
        contributors = get_authors(from_schema_org_contributors(Array.wrap(meta.fetch("editor",
                                                                                      nil))))
        publisher = parse_attributes(meta.fetch("publisher", nil), content: "name", first: true)

        ct = schema_org == "Dataset" ? "includedInDataCatalog" : "Periodical"
        container = if meta.fetch(ct, nil).present?
            url = parse_attributes(from_schema_org(meta.fetch(ct, nil)), content: "url",
                                                                         first: true)

            {
                        "type" => schema_org == "Dataset" ? "DataRepository" : "Periodical",
                        "title" => parse_attributes(from_schema_org(meta.fetch(ct, nil)), content: "name",
                                                                                          first: true),
                        "identifier" => url,
                        "identifierType" => url.present? ? "URL" : nil,
                        "volume" => meta.fetch("volumeNumber", nil),
                        "issue" => meta.fetch("issueNumber", nil),
                        "firstPage" => meta.fetch("pageStart", nil),
                        "lastPage" => meta.fetch("pageEnd", nil),
                      }.compact
          elsif %w[BlogPosting Article].include?(schema_org)
            issn = meta.dig("isPartOf", "issn")
            url = meta.dig("publisher", "url")

            {
                        "type" => "Blog",
                        "title" => meta.dig("isPartOf", "name"),
                        "identifier" => issn.presence || url.presence,
                        "identifierType" => issn.present? ? "ISSN" : "URL",
                      }.compact
          else
            {}
          end

        related_identifiers = Array.wrap(schema_org_is_identical_to(meta)) +
                              Array.wrap(schema_org_is_part_of(meta)) +
                              Array.wrap(schema_org_has_part(meta)) +
                              Array.wrap(schema_org_is_previous_version_of(meta)) +
                              Array.wrap(schema_org_is_new_version_of(meta)) +
                              Array.wrap(schema_org_references(meta)) +
                              Array.wrap(schema_org_is_referenced_by(meta)) +
                              Array.wrap(schema_org_is_supplement_to(meta)) +
                              Array.wrap(schema_org_is_supplemented_by(meta))

        rights_list = Array.wrap(meta.fetch("license", nil)).compact.map do |rl|
          if rl.is_a?(String)
            hsh_to_spdx("rightsURI" => rl)
          else
            hsh_to_spdx("__content__" => rl["name"], "rightsURI" => rl["id"])
          end
        end

        funding_references = Array.wrap(meta.fetch("funder", nil)).compact.map do |fr|
          if fr["@id"].present?
            {
              "funderName" => fr["name"],
              "funderIdentifier" => fr["@id"],
              "funderIdentifierType" => fr["@id"].to_s.start_with?("https://doi.org/10.13039") ? "Crossref Funder ID" : "Other",
            }.compact
          else
            { "funderName" => fr["name"] }.compact
          end
        end

        # strip milliseconds from iso8601, as edtf library doesn't handle them
        dates = []
        if Date.edtf(strip_milliseconds(meta.fetch("datePublished", nil))).present?
          dates << { "date" => strip_milliseconds(meta.fetch("datePublished")),
                     "dateType" => "Issued" }
        end
        if Date.edtf(strip_milliseconds(meta.fetch("dateCreated", nil))).present?
          dates << { "date" => strip_milliseconds(meta.fetch("dateCreated")),
                     "dateType" => "Created" }
        end
        if Date.edtf(strip_milliseconds(meta.fetch("dateModified", nil))).present?
          dates << { "date" => strip_milliseconds(meta.fetch("dateModified")),
                     "dateType" => "Updated" }
        end
        publication_year = meta.fetch("datePublished")[0..3] if meta.fetch("datePublished",
                                                                           nil).present?

        language = case meta.fetch("inLanguage", nil)
          when String
            meta.fetch("inLanguage")
          when Array
            meta.fetch("inLanguage").first
          when Object
            meta.dig("inLanguage", "alternateName") || meta.dig("inLanguage", "name")
          end

        state = meta.present? || read_options.present? ? "findable" : "not_found"
        geo_locations = Array.wrap(meta.fetch("spatialCoverage", nil)).map do |gl|
          if gl.dig("geo", "box")
            s, w, n, e = gl.dig("geo", "box").split(" ", 4)
            geo_location_box = {
              "westBoundLongitude" => w,
              "eastBoundLongitude" => e,
              "southBoundLatitude" => s,
              "northBoundLatitude" => n,
            }.compact.presence
          else
            geo_location_box = nil
          end
          geo_location_point = { "pointLongitude" => gl.dig("geo", "longitude"),
                                 "pointLatitude" => gl.dig("geo", "latitude") }.compact.presence

          {
            "geoLocationPlace" => gl.dig("geo", "address"),
            "geoLocationPoint" => geo_location_point,
            "geoLocationBox" => geo_location_box,
          }.compact
        end

        # handle keywords as array and as comma-separated string
        subjects = meta.fetch("keywords", nil)
        subjects = subjects.to_s.downcase.split(", ") if subjects.is_a?(String)
        subjects = Array.wrap(subjects).reduce([]) do |sum, subject|
          sum += name_to_fos(subject)
          sum
        end

        schema_version = meta.fetch("schemaVersion", nil).to_s.presence || "http://datacite.org/schema/kernel-4"

        { "id" => id,
          "types" => types,
          "doi" => validate_doi(id),
          "identifiers" => identifiers,
          "url" => normalize_id(meta.fetch("url", nil)),
          "content_url" => Array.wrap(meta.fetch("contentUrl", nil)),
          "sizes" => Array.wrap(meta.fetch("contenSize", nil)),
          "formats" => Array.wrap(meta.fetch("encodingFormat",
                                             nil) || meta.fetch("fileFormat", nil)),
          "titles" => if meta.fetch("name", nil).present?
          [{ "title" => meta.fetch("name", nil) }]
        else
          [{ "title" => meta.fetch("headline", nil) }]
        end,
          "creators" => creators,
          "contributors" => contributors,
          "publisher" => publisher,
          "agency" => parse_attributes(meta.fetch("provider", nil), content: "name", first: true),
          "container" => container,
          "related_identifiers" => related_identifiers,
          "publication_year" => publication_year,
          "dates" => dates,
          "descriptions" => if meta.fetch("description", nil).present?
          [{ "description" => sanitize(meta.fetch("description")),
             "descriptionType" => "Abstract" }]
        end,
          "rights_list" => rights_list.presence,
          "version_info" => meta.fetch("version", nil).to_s.presence,
          "subjects" => subjects,
          "language" => language,
          "state" => state,
          "schema_version" => schema_version,
          "funding_references" => funding_references,
          "geo_locations" => geo_locations }.compact.merge(read_options)
      end

      def schema_org_related_identifier(meta, relation_type: nil)
        normalize_ids(ids: meta.fetch(relation_type, nil),
                      relation_type: SO_TO_DC_RELATION_TYPES[relation_type])
      end

      def schema_org_reverse_related_identifier(meta, relation_type: nil)
        normalize_ids(ids: meta.dig("@reverse", relation_type),
                      relation_type: SO_TO_DC_REVERSE_RELATION_TYPES[relation_type])
      end

      def schema_org_is_identical_to(meta)
        schema_org_related_identifier(meta, relation_type: "sameAs")
      end

      def schema_org_is_part_of(meta)
        schema_org_related_identifier(meta, relation_type: "isPartOf")
      end

      def schema_org_has_part(meta)
        schema_org_related_identifier(meta, relation_type: "hasPart")
      end

      def schema_org_is_previous_version_of(meta)
        schema_org_related_identifier(meta, relation_type: "PredecessorOf")
      end

      def schema_org_is_new_version_of(meta)
        schema_org_related_identifier(meta, relation_type: "SuccessorOf")
      end

      def schema_org_references(meta)
        schema_org_related_identifier(meta, relation_type: "citation")
      end

      def schema_org_is_referenced_by(meta)
        schema_org_reverse_related_identifier(meta, relation_type: "citation")
      end

      def schema_org_is_supplement_to(meta)
        schema_org_reverse_related_identifier(meta, relation_type: "isBasedOn")
      end

      def schema_org_is_supplemented_by(meta)
        schema_org_related_identifier(meta, relation_type: "isBasedOn")
      end
    end
  end
end
