# frozen_string_literal: true

module Briard
  module Writers
    module CrossrefWriter
      def crossref
        should_passthru ? raw : crossref_xml
      end
    end
  end
end
