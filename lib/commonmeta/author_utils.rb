# frozen_string_literal: true

require "namae"

module Commonmeta
  module AuthorUtils
    # include BenchmarkMethods
    #
    # benchmark :get_authors

    def get_one_author(author)
      # basic sanity checks
      return nil if author.blank?

      # author is a string
      author = { "name" => author } if author.is_a?(String)

      # malformed XML
      return nil if author.fetch("name", nil).is_a?(Array)

      # parse author name attributes
      name = parse_attributes(author.fetch("name", nil)) ||
             parse_attributes(author.fetch("creatorName", nil)) ||
             parse_attributes(author.fetch("contributorName", nil))

      given_name = parse_attributes(author.fetch("givenName", nil)) ||
                   parse_attributes(author.fetch("given", nil))
      family_name = parse_attributes(author.fetch("familyName", nil)) ||
                    parse_attributes(author.fetch("family", nil))

      # parse author identifier
      id = author.fetch("id", nil)

      # DataCite metadata
      if id.nil? && author["nameIdentifiers"].present?
        id = Array.wrap(author.dig("nameIdentifiers")).find { |ni| ni["nameIdentifierScheme"] == "ORCID" }
        id = id["nameIdentifier"] if id.present?
      # Crossref metadata
      elsif id.nil? && author["ORCID"].present?
        id = author.fetch("ORCID")
      end
      id = normalize_orcid(id)

      # parse author type, i.e. "Person", "Organization" or not specified
      type = author.fetch("type", nil)
      type = type.first if type.is_a?(Array)
      # DataCite metadata
      type = type[0..-3] if type.is_a?(String) && type.end_with?("al")

      if type.blank? && id.is_a?(String) && URI.parse(id).host == "ror.org"
        type = "Organization"
      elsif type.blank? && id.is_a?(String) && URI.parse(id).host == "orcid.org"
        type = "Person"
      elsif type.blank? && (given_name.present? || family_name.present?)
        type = "Person"
      elsif type.blank? && is_personal_name?(name: name) && name.to_s.exclude?(";")
        type = "Person"
      end

      # parse author contributor role
      contributor_type = parse_attributes(author.fetch("contributorType", nil))
      
      name = cleanup_author(name)

      # split name for type Person into given/family name if not already provided
      if type == 'Person' && given_name.blank? && family_name.blank?
        Namae.options[:include_particle_in_family] = true
        names = Namae.parse(name)
        parsed_name = names.first

        if parsed_name.present?
          given_name = parsed_name.given
          family_name = parsed_name.family
        else
          given_name = nil
          family_name = nil
        end
      end

      # return author in commonmeta format, using name vs. given/family name 
      # depending on type
      { "id" => id,
        "type" => type,
        "name" => type == "Person" ? nil : name,
        "givenName" => type == "Organization" ? nil : given_name,
        "familyName" => type == "Organization" ? nil : family_name,
        "affiliation" => get_affiliations(author.fetch("affiliation", nil)),
        "contributorType" => contributor_type }.compact
    end

    def cleanup_author(author)
      return nil unless author.present?

      # detect pattern "Smith J.", but not "Smith, John K."
      unless author.include?(",")
        author = author.gsub(/[[:space:]]([A-Z]\.)?(-?[A-Z]\.)$/, ', \1\2')
      end

      # remove spaces around hyphens
      author = author.gsub(" - ", "-")

      # remove non-standard space characters
      author.gsub(/[[:space:]]/, " ")
    end

    # check if given name is in the database of known given names:
    # https://github.com/bmuller/gender_detector
    def is_personal_name?(name: nil)
      return true if name_exists?(name.to_s.split.first) ||
                     name_exists?(name.to_s.split(", ").last)
      false
    end

    # recognize given name if we have loaded ::NameDetector data, e.g. in a Rails initializer
    def name_exists?(name)
      return false unless name_detector.present?

      name_detector.name_exists?(name)
    end

    # parse array of author strings into commonmeta format
    def get_authors(authors)
      Array.wrap(authors).map { |author| get_one_author(author) }.compact
    end

    def authors_as_string(authors)
      Array.wrap(authors).map do |a|
        if a["familyName"].present?
          [a["familyName"], a["givenName"]].join(", ")
        elsif a["type"] == "Person"
          a["name"]
        elsif a["name"].present?
          "{#{a["name"]}}"
        end
      end.join(" and ").presence
    end

    def get_affiliations(affiliations)
      return nil unless affiliations.present?

      Array.wrap(affiliations).map do |a|
        affiliation_identifier = nil
        if a.is_a?(String)
          name = a.squish
        elsif a.is_a?(Hash)
          if a["affiliationIdentifier"].present?
            affiliation_identifier = a["affiliationIdentifier"]
            if a["schemeURI"].present?
              schemeURI = a["schemeURI"].end_with?("/") ? a["schemeURI"] : "#{a["schemeURI"]}/"
            end
            affiliation_identifier = !affiliation_identifier.to_s.start_with?("https://") && schemeURI.present? ? normalize_id(schemeURI + affiliation_identifier) : normalize_id(affiliation_identifier)
          end
          name = (a["name"] || a["__content__"]).to_s.squish.presence
        end

        next unless name.present?

        { "id" => affiliation_identifier,
          "name" => name }.compact
      end.compact.presence
    end

    def author_name_identifiers(id)
      return nil unless id.present?

      Array.wrap(id).map do |i|
        { "nameIdentifier" => i,
          "nameIdentifierScheme" => "ORCID",
          "schemeUri" => "https://orcid.org" }.compact
      end.compact.presence
    end
  end
end
