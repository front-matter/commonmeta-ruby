# frozen_string_literal: true

module Briard
  module Writers
    module DataciteXmlWriter
      # generate new DataCite XML version 4.0 if regenerate (!should_passthru) option is provided
      def datacite_xml
        should_passthru ? raw : write_datacite_xml
      end
    end
  end
end
