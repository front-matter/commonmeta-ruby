# frozen_string_literal: true

module Commonmeta
  module Writers
    module RdfXmlWriter
      def rdf_xml
        graph.dump(:rdfxml, prefixes: { schema: "http://schema.org/" })
      end
    end
  end
end
