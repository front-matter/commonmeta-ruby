# frozen_string_literal: true

module Briard
  module Readers
    module DataciteJsonReader
      def read_datacite_json(string: nil, **_options)
        errors = jsonlint(string)
        return { 'errors' => errors } if errors.present?

        string.present? ? Maremma.from_json(string).transform_keys!(&:underscore) : {}
      end
    end
  end
end
