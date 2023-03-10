# frozen_string_literal: true

module Briard
  module Readers
    module DataciteReader
      def get_datacite(id: nil, **options)
        return { 'string' => nil, 'state' => 'not_found' } unless id.present?

        api_url = datacite_api_url(id, options)
        response = Maremma.get(api_url)
        attributes = response.body.dig('data', 'attributes')
        return { 'string' => nil, 'state' => 'not_found' } unless attributes.present?

        string = attributes

        client = Array.wrap(response.body.fetch('included', nil)).find do |m|
          m['type'] == 'clients'
        end
        client_id = client.to_h.fetch('id', nil)
        provider_id = Array.wrap(client.to_h.fetch('relationships', nil)).find do |m|
          m['provider'].present?
        end.to_h.dig('provider', 'data', 'id')

        content_url = attributes.fetch('contentUrl',
                                       nil) || Array.wrap(response.body.fetch('included',
                                                                              nil)).select do |m|
                                                 m['type'] == 'media'
                                               end.map do |m|
                                                 m.dig('attributes', 'url')
                                               end.compact

        { 'string' => string,
          'url' => attributes.fetch('url', nil),
          'state' => attributes.fetch('state', nil),
          'date_registered' => attributes.fetch('registered', nil),
          'date_updated' => attributes.fetch('updated', nil),
          'provider_id' => provider_id,
          'client_id' => client_id,
          'content_url' => content_url }
      end

      def read_datacite(string: nil, **_options)
        errors = jsonlint(string)
        return { 'errors' => errors } if errors.present?

        string.present? ? Maremma.from_json(string).transform_keys!(&:underscore) : {}
      end
    end
  end
end
