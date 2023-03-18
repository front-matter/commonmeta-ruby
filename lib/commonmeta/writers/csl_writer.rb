# frozen_string_literal: true

module Commonmeta
  module Writers
    module CslWriter
      def csl
        JSON.pretty_generate csl_hsh.presence
      end
    end
  end
end
