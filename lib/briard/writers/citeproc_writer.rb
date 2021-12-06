# frozen_string_literal: true

module Briard
  module Writers
    module CiteprocWriter
      def citeproc
        JSON.pretty_generate citeproc_hsh.presence
      end
    end
  end
end
