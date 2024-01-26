# frozen_string_literal: true

module Commonmeta
  module Readers
    module CommonmetaReader
      def read_commonmeta(string: nil, **options)
        if string.present?
          errors = jsonlint(string)
          return { "errors" => errors } if errors.present?
        end

        read_options = ActiveSupport::HashWithIndifferentAccess.new(options.except(:doi, :id, :url,
                                                                                   :sandbox, :validate, :ra))
        meta = string.present? ? JSON.parse(string) : {}
        meta["schema_version"] = "https://commonmeta.org/commonmeta_v0.10"
        meta.compact.merge(read_options)
      end
    end
  end
end
