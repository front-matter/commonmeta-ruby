# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  subject { described_class.new(input: input, from: 'crossref') }

  let(:input) { 'https://doi.org/10.1101/097196' }

  context 'json_schema_errors' do
    it 'is_valid' do
      response = subject.json_schema_errors
      expect(response).to be_nil
    end

    it 'no creator' do
      input = "#{fixture_path}datacite_missing_creator.xml"
      subject = described_class.new(input: input, regenerate: true)
      expect(subject.creators).to be_empty
      expect(subject.valid?).to be false
      expect(subject.json_schema_errors).to be nil
    end
  end
end
