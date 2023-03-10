# frozen_string_literal: true
require "json_schemer"
require "pathname"

module Briard
  module SchemaUtils
    DATACITE_V3 = schema = File.read(File.expand_path("../../resources/datacite-v3.json", __dir__))
    DATACITE_V4 = schema = File.read(File.expand_path("../../resources/datacite-v4.json", __dir__))

    def json_schema_errors(schema_version: "http://datacite.org/schema/kernel-4")
      case schema_version
      when "http://datacite.org/schema/kernel-3", "http://datacite.org/schema/kernel-3.0", "http://datacite.org/schema/kernel-3.1"
        schemer = JSONSchemer.schema(DATACITE_V3)
      else
        schemer = JSONSchemer.schema(DATACITE_V4)
      end

      errors = schemer.validate(self.meta).to_a
      errors.map { |err| JSONSchemer::Errors.pretty err }.presence
    end
  end
end
