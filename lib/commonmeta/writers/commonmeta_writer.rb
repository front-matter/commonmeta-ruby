# frozen_string_literal: true

module Commonmeta
  module Writers
    module CommonmetaWriter
      def commonmeta
        JSON.pretty_generate meta
      end
    end
  end
end