# frozen_string_literal: true

module Briard
  module Writers
    module CrossciteWriter
      def crosscite
        JSON.pretty_generate crosscite_hsh.presence
      end
    end
  end
end
