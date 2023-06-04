# frozen_string_literal: true

require_relative 'author_utils'
require_relative 'crossref_utils'
require_relative 'doi_utils'
require_relative 'schema_utils'
require_relative 'utils'

require_relative 'readers/bibtex_reader'
require_relative 'readers/cff_reader'
require_relative 'readers/csl_reader'
require_relative 'readers/codemeta_reader'
require_relative 'readers/crossref_reader'
require_relative 'readers/crossref_xml_reader'
require_relative 'readers/datacite_reader'
require_relative 'readers/json_post_reader'
require_relative 'readers/npm_reader'
require_relative 'readers/ris_reader'
require_relative 'readers/schema_org_reader'

require_relative 'writers/bibtex_writer'
require_relative 'writers/citation_writer'
require_relative 'writers/cff_writer'
require_relative 'writers/codemeta_writer'
require_relative 'writers/crossref_xml_writer'
require_relative 'writers/csl_writer'
require_relative 'writers/csv_writer'
require_relative 'writers/datacite_writer'
require_relative 'writers/jats_writer'
require_relative 'writers/rdf_xml_writer'
require_relative 'writers/ris_writer'
require_relative 'writers/schema_org_writer'
require_relative 'writers/turtle_writer'

module Commonmeta
  module MetadataUtils
    include Commonmeta::AuthorUtils
    include Commonmeta::CrossrefUtils
    include Commonmeta::DoiUtils
    include Commonmeta::SchemaUtils
    include Commonmeta::Utils

    include Commonmeta::Readers::BibtexReader
    include Commonmeta::Readers::CffReader
    include Commonmeta::Readers::CodemetaReader
    include Commonmeta::Readers::CrossrefReader
    include Commonmeta::Readers::CrossrefXmlReader
    include Commonmeta::Readers::CslReader
    include Commonmeta::Readers::DataciteReader
    include Commonmeta::Readers::JsonPostReader
    include Commonmeta::Readers::NpmReader
    include Commonmeta::Readers::RisReader
    include Commonmeta::Readers::SchemaOrgReader

    include Commonmeta::Writers::BibtexWriter
    include Commonmeta::Writers::CitationWriter
    include Commonmeta::Writers::CffWriter
    include Commonmeta::Writers::CodemetaWriter
    include Commonmeta::Writers::CrossrefXmlWriter
    include Commonmeta::Writers::CslWriter
    include Commonmeta::Writers::CsvWriter
    include Commonmeta::Writers::DataciteWriter
    include Commonmeta::Writers::JatsWriter
    include Commonmeta::Writers::RdfXmlWriter
    include Commonmeta::Writers::RisWriter
    include Commonmeta::Writers::SchemaOrgWriter
    include Commonmeta::Writers::TurtleWriter

    attr_reader :name_detector, :reverse

    # some dois in the Crossref index are from other registration agencies
    alias get_medra get_crossref
    alias read_medra read_crossref
    alias get_kisti get_crossref
    alias read_kisti read_crossref
    alias get_jalc get_crossref
    alias read_jalc read_crossref
    alias get_op get_crossref
    alias read_op read_crossref

    def raw
      r = string.present? ? string.strip : nil
      return r unless from == 'crossref_xml' && r.present?

      r
    end

    def should_passthru
      (from == 'crossref_xml') && regenerate.blank? && raw.present?
    end

    def container_title
      if container.present?
        container['title']
      elsif type == 'Article'
        publisher['name']
      end
    end

    # recognize given name. Can be loaded once as ::NameDetector, e.g. in a Rails initializer
    def name_detector
      @name_detector ||= defined?(::NameDetector) ? ::NameDetector : nil
    end

    def reverse
      { 'citation' => Array.wrap(related_identifiers).select do |ri|
        ri['relationType'] == 'IsReferencedBy'
      end.map do |r|
        { '@id' => normalize_doi(r['relatedIdentifier']),
          '@type' => r['resourceTypeGeneral'] || 'ScholarlyArticle',
          'identifier' => r['relatedIdentifierType'] == 'DOI' ? nil : to_identifier(r) }.compact
      end.unwrap,
        'isBasedOn' => Array.wrap(related_identifiers).select do |ri|
                         ri['relationType'] == 'IsSupplementTo'
                       end.map do |r|
                         { '@id' => normalize_doi(r['relatedIdentifier']),
                           '@type' => r['resourceTypeGeneral'] || 'ScholarlyArticle',
                           'identifier' => r['relatedIdentifierType'] == 'DOI' ? nil : to_identifier(r) }.compact
                       end.unwrap }.compact
    end

    def graph
      # preload schema_org context
      JSON::LD::Context.add_preloaded(
        'http://schema.org/',
        JSON::LD::Context.new.parse('resources/schema_org/jsonldcontext.json')
      )

      RDF::Graph.new << JSON::LD::API.toRdf(schema_hsh)
    rescue NameError
      nil
    end

    def csl_hsh
      page = if container.to_h['firstPage'].present?
               [container['firstPage'], container['lastPage']].compact.join('-')
             end
      author = if Array.wrap(creators).size == 1 && Array.wrap(creators).first.fetch('name',
                                                                                     nil) == ':(unav)'
                 nil
               else
                 to_csl(creators)
               end

      type_ = if type == 'Software' && version.present?
                'book'
              else
                CM_TO_CSL_TRANSLATIONS.fetch(type, 'document')
              end

      categories = Array.wrap(subjects).map do |k|
        parse_attributes(k, content: 'subject', first: true)
      end.presence

      {
        'type' => type_,
        'id' => id,
        'categories' => categories,
        'language' => language,
        'author' => author,
        'contributor' => to_csl(contributors),
        'issued' => get_date_parts(date['published']),
        'submitted' => date['submitted'] ? get_date_parts(date['submitted']) : nil,
        'abstract' => parse_attributes(descriptions, content: 'description', first: true),
        'container-title' => container_title,
        'DOI' => doi_from_url(id),
        'volume' => container.to_h['volume'],
        'issue' => container.to_h['issue'],
        'page' => page,
        'publisher' => publisher['name'],
        'title' => parse_attributes(titles, content: 'title', first: true),
        'URL' => url,
        'copyright' => license.to_h['id'],
        'version' => version
      }.compact.symbolize_keys
    end

    def style
      @style ||= 'apa'
    end

    def locale
      @locale ||= 'en-US'
    end
  end
end
