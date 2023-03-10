# frozen_string_literal: true

module Briard
  module Writers
    module CrossrefXmlWriter
      def crossref_xml
        should_passthru ? raw : crossref_xml
      end
    end
  end
end
