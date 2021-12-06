# frozen_string_literal: true

module Briard
  module Writers
    module TurtleWriter
      def turtle
        graph.dump(:ttl, prefixes: { schema: "http://schema.org/" })
      end
    end
  end
end
