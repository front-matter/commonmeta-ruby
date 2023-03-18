# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input, from: 'crossref') }

  let(:input) { 'https://doi.org/10.1101/097196' }

  context 'json_schema_errors' do
    it 'is_valid' do
      response = subject.json_schema_errors
      expect(response).to be_nil
    end
  end
end
