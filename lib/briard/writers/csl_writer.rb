# frozen_string_literal: true

module Briard
  module Writers
    module CslWriter
      def csl
        JSON.pretty_generate csl_hsh.presence
      end
    end
  end
end
