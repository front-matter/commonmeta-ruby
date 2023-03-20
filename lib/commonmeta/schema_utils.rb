# frozen_string_literal: true

require 'json_schemer'
require 'pathname'

module Commonmeta
  module SchemaUtils
    # DATACITE_V3 = schema = File.read(File.expand_path("../../resources/datacite-v3.json", __dir__))
    # DATACITE_V4 = schema = File.read(File.expand_path("../../resources/datacite-v4.json", __dir__))
    COMMONMETA = schema = File.read(File.expand_path('../../resources/commonmeta_v0.9.json',
                                                     __dir__))

    def json_schema_errors(schema_version: nil)
      schemer = JSONSchemer.schema(COMMONMETA)
      errors = schemer.validate(meta).to_a
      errors.map { |err| JSONSchemer::Errors.pretty err }.presence
    end
  end
end
