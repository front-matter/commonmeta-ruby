# frozen_string_literal: true

module Commonmeta
  module Writers
    module CrossrefXmlWriter
      def crossref_xml
        should_passthru ? raw : write_crossref_xml
      end
    end
  end
end
