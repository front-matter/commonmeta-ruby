# frozen_string_literal: true

require "json_schemer"
require "pathname"

module Commonmeta
  module SchemaUtils
    COMMONMETA = File.read(File.expand_path("../../resources/commonmeta_v0.10.8.json",
                                            __dir__))

    def json_schema_errors
      schemer = JSONSchemer.schema(COMMONMETA)
      errors = schemer.validate(meta).to_a
      errors.map { |err| JSONSchemer::Errors.pretty err }.presence
    end
  end
end
