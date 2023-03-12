# frozen_string_literal: true

require 'namae'

module Briard
  module AuthorUtils
    # include BenchmarkMethods
    #
    # benchmark :get_authors

    IDENTIFIER_SCHEME_URIS = { 'ORCID' => 'https://orcid.org/' }.freeze

    def get_one_author(author)
      # author is a string
      author = { 'creatorName' => author } if author.is_a?(String)

      # malformed XML
      return nil if author.fetch('creatorName', nil).is_a?(Array)

      name = parse_attributes(author.fetch('creatorName', nil)) ||
             parse_attributes(author.fetch('contributorName', nil)) ||
             parse_attributes(author.fetch('name', nil))
      given_name = parse_attributes(author.fetch('givenName', nil)) ||
                   parse_attributes(author.fetch('given', nil))
      family_name = parse_attributes(author.fetch('familyName', nil)) ||
                    parse_attributes(author.fetch('family', nil))
      name = cleanup_author(name)
      name = [family_name, given_name].join(', ') if family_name.present? && given_name.present?
      contributor_type = parse_attributes(author.fetch('contributorType', nil))
      name_type = author.fetch('nameType', nil)
                     
      name_identifiers = author.fetch('nameIdentifiers', nil) || Array.wrap(author.fetch('nameIdentifier', nil)).map do |ni|
        if ni['nameIdentifierScheme'] == 'ORCID'
          {
            'nameIdentifier' => normalize_orcid(ni['__content__']),
            'schemeUri' => 'https://orcid.org',
            'nameIdentifierScheme' => 'ORCID'
          }.compact
        elsif ni['schemeURI'].present?
          {
            'nameIdentifier' => ni['schemeURI'].to_s + ni['__content__'].to_s,
            'schemeUri' => ni['schemeURI'].to_s,
            'nameIdentifierScheme' => ni['nameIdentifierScheme']
          }.compact
        else
          {
            'nameIdentifier' => ni['__content__'],
            'schemeUri' => nil,
            'nameIdentifierScheme' => ni['nameIdentifierScheme']
          }.compact
        end
      end.presence

      # Crossref metadata
      if name_identifiers.blank? && author['ORCID'].present?
        name_identifiers = [{
          'nameIdentifier' => normalize_orcid(author.fetch('ORCID')),
          'schemeUri' => 'https://orcid.org',
          'nameIdentifierScheme' => 'ORCID' }]
      end

      if name_type.blank? && Array.wrap(name_identifiers).find { |ni| ni['nameIdentifierScheme'] == 'ORCID' }.present?
        name_type = 'Personal'
      elsif name_type.blank? && Array.wrap(name_identifiers).find { |ni| %w(ISNI ROR).include? ni['nameIdentifierScheme'] }.present?
        name_type = 'Organizational'
      elsif name_type.blank? && is_personal_name?(given_name: given_name, name: name) && name.to_s.exclude?(';')
        name_type = 'Personal'
      elsif name_type.blank? && (given_name.present? || family_name.present?)
        name_type = 'Personal'
      end

      author = { 
        'nameType' => name_type,
        'name' => name,
        'givenName' => given_name,
        'familyName' => family_name,
        'nameIdentifiers' => name_identifiers.presence,
        'affiliation' => get_affiliations(author.fetch('affiliation', nil)),
        'contributorType' => contributor_type }.compact

      return author if family_name.present?

      if name_type == 'Personal'
        Namae.options[:include_particle_in_family] = true
        names = Namae.parse(name)
        parsed_name = names.first
        
        if parsed_name.present?
          given_name = parsed_name.given
          family_name = parsed_name.family
          name = [family_name, given_name].join(', ')
        else
          given_name = nil
          family_name = nil
        end

        { 'nameType' => 'Personal',
          'name' => name,
          'givenName' => given_name,
          'familyName' => family_name,
          'nameIdentifiers' => name_identifiers,
          'affiliation' => get_affiliations(author.fetch('affiliation', nil)),
          'contributorType' => contributor_type }.compact
      else
        { 'nameType' => name_type,
          'name' => name,
          'nameIdentifiers' => name_identifiers.presence,
          'affiliation' => get_affiliations(author.fetch('affiliation', nil)),
          'contributorType' => contributor_type }.compact
      end
    end

    def cleanup_author(author)
      return nil unless author.present?

      # detect pattern "Smith J.", but not "Smith, John K."
      unless author.include?(',')
        author = author.gsub(/[[:space:]]([A-Z]\.)?(-?[A-Z]\.)$/, ', \1\2')
      end

      # remove spaces around hyphens
      author = author.gsub(' - ', '-')

      # remove non-standard space characters
      author.gsub(/[[:space:]]/, ' ')
    end

    # check if given name is in the database of known given names:
    # https://github.com/bmuller/gender_detector
    def is_personal_name?(given_name: nil, name: nil)
      return true if name_exists?(given_name.to_s) ||
                     name_exists?(name.to_s.split.first) ||
                     name_exists?(name.to_s.split(', ').last)
      false
    end

    # recognize given name if we have loaded ::NameDetector data, e.g. in a Rails initializer
    def name_exists?(name)
      return false unless name_detector.present?

      name_detector.name_exists?(name)
    end

    # parse array of author strings into CSL format
    def get_authors(authors)
      Array.wrap(authors).map { |author| get_one_author(author) }.compact
    end

    def authors_as_string(authors)
      Array.wrap(authors).map do |a|
        if a['familyName'].present?
          [a['familyName'], a['givenName']].join(', ')
        elsif a['type'] == 'Person'
          a['name']
        elsif a['name'].present?
          "{#{a['name']}}"
        end
      end.join(' and ').presence
    end

    def get_affiliations(affiliations)
      return nil unless affiliations.present?

      Array.wrap(affiliations).map do |a|
        affiliation_identifier = nil
        if a.is_a?(String)
          name = a.squish
          affiliation_identifier_scheme = nil
          scheme_uri = nil
        else
          if a['affiliationIdentifier'].present?
            affiliation_identifier = a['affiliationIdentifier']
            if a['schemeURI'].present?
              schemeURI = a['schemeURI'].end_with?('/') ? a['schemeURI'] : "#{a['schemeURI']}/"
            end
            affiliation_identifier = !affiliation_identifier.to_s.start_with?('https://') && schemeURI.present? ? normalize_id(schemeURI + affiliation_identifier) : normalize_id(affiliation_identifier)
          end
          name = (a['name'] || a['__content__']).to_s.squish.presence
          affiliation_identifier_scheme = a['affiliationIdentifierScheme']
          scheme_uri = a['SchemeURI']
        end

        next unless name.present?

        { 'name' => name,
          'affiliationIdentifier' => affiliation_identifier,
          'affiliationIdentifierScheme' => affiliation_identifier_scheme,
          'schemeUri' => scheme_uri }.compact
      end.compact.presence
    end
  end
end
