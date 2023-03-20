# frozen_string_literal: true

module Commonmeta
  module DoiUtils
    def validate_doi(doi)
      doi = Array(%r{\A(?:(http|https):/(/)?(dx\.)?(doi\.org|handle\.stage\.datacite\.org|handle\.test\.datacite\.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}.match(doi)).last
      # remove non-printing whitespace and downcase
      doi.delete("\u200B").downcase if doi.present?
    end

    def validate_funder_doi(doi)
      doi = Array(%r{\A(?:(http|https):/(/)?(dx\.)?(doi\.org|handle\.stage\.datacite\.org|handle\.test\.datacite\.org)/)?(doi:)?(10\.13039/)?([1-9]\d+)\z}.match(doi)).last

      # remove non-printing whitespace and downcase
      return unless doi.present?

      doi.delete("\u200B").downcase
      "https://doi.org/10.13039/#{doi}"
    end

    def validate_prefix(doi)
      Array(%r{\A(?:(http|https):/(/)?(dx\.)?(doi\.org|handle\.stage\.datacite\.org|handle\.test\.datacite\.org)/)?(doi:)?(10\.\d{4,5}).*\z}.match(doi)).last
    end

    def doi_resolver(doi, options = {})
      sandbox = Array(/handle\.stage\.datacite\.org/.match(doi)).last
      sandbox.present? || options[:sandbox] ? 'https://handle.stage.datacite.org/' : 'https://doi.org/'
    end

    def datacite_api_url(doi, options = {})
      sandbox = Array(/handle\.stage\.datacite.\org/.match(doi)).last
      sandbox.present? || options[:sandbox] ? "https://api.stage.datacite.org/dois/#{doi_from_url(doi)}?include=media,client" : "https://api.datacite.org/dois/#{doi_from_url(doi)}?include=media,client"
    end

    def crossref_api_url(doi, _options = {})
      "https://api.crossref.org/works/#{doi_from_url(doi)}"
    end

    def normalize_doi(doi, options = {})
      doi_str = validate_doi(doi)
      return nil unless doi_str.present?

      # turn DOI into URL, escape unsafe characters
      doi_resolver(doi, options) + Addressable::URI.encode(doi_str)
    end

    def doi_from_url(url)
      unless %r{\A(?:(http|https)://(dx\.)?(doi\.org|handle\.stage\.datacite\.org|handle\.test\.datacite\.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}.match?(url)
        return
      end

      uri = Addressable::URI.parse(url)
      uri.path.gsub(%r{^/}, '').downcase
    end

    def doi_as_url(doi)
      "https://doi.org/#{doi}" if doi.present?
    end

    # get DOI registration agency
    def get_doi_ra(doi)
      prefix = validate_prefix(doi)
      return nil if prefix.blank?

      url = "https://doi.org/ra/#{prefix}"
      response = HTTP.get(url)
      body = JSON.parse(response.body)
      body.dig(0, 'RA')
    end

    # get Crossref member name from id
    def get_crossref_member(member_id)
      url = "https://api.crossref.org/members/#{member_id}"
      response = HTTP.get(url)
      body = JSON.parse(response.body)
      name = body.dig('message', 'primary-name')

      { 'id' => "https://api.crossref.org/members/#{member_id}", 'name' => name }
    end
  end
end
