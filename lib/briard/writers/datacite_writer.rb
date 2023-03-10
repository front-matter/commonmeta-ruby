# frozen_string_literal: true

module Briard
  # frozen_string_literal: true

  module Writers
    module DataciteWriter
      def datacite
        return unless crosscite_hsh.present?

        JSON.pretty_generate crosscite_hsh.transform_keys! { |key|
                               key.camelcase(uppercase_first_letter = :lower)
                             }
      end
    end
  end
end
