# frozen_string_literal: true
require 'json_schemer'
require 'pathname'

module Briard
  module SchemaUtils
    JSON_SCHEMA = schema = File.read(File.expand_path('../../resources/json-schema/briard_schema.json', __dir__))
    
    def json_schema_errors
      schemer = JSONSchemer.schema(JSON_SCHEMA)
      errors = schemer.validate(self.meta).to_a
      errors.map {|err| JSONSchemer::Errors.pretty err }.presence
    end
  end
end
