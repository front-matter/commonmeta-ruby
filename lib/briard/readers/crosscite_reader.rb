# frozen_string_literal: true

module Briard
  module Readers
    module CrossciteReader
      def read_crosscite(string: nil, **_options)
        errors = jsonlint(string)
        return { 'errors' => errors } if errors.present?

        string.present? ? Maremma.from_json(string) : {}
      end
    end
  end
end
