# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { 'https://github.com/datacite/maremma/blob/master/codemeta.json' }

  context 'get codemeta raw' do
    it 'rdataone' do
      input = "#{fixture_path}codemeta.json"
      subject = described_class.new(input: input)
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context 'get codemeta metadata' do
    it 'maremma' do
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(subject.url).to eq('https://github.com/datacite/maremma')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'DataCite' }],
                                        'familyName' => 'Fenner',
                                        'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-0077-4738',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Maremma: a Ruby library for simplified network calls' }])
      expect(subject.descriptions.first['description']).to start_with('Ruby utility library for network requests')
      expect(subject.subjects).to eq([{ 'subject' => 'faraday' }, { 'subject' => 'excon' },
                                      { 'subject' => 'net/http' }])
      expect(subject.date).to eq('created' => '2015-11-28',
                                 'published' => '2017-02-24',
                                 'updated' => '2017-02-24')
      expect(subject.publisher).to eq('name' => 'DataCite')
      expect(subject.license).to eq('id' => 'MIT', 'url' => 'https://opensource.org/licenses/MIT')
    end

    it 'rdataone' do
      input = "#{fixture_path}codemeta.json"
      subject = described_class.new(input: input)
      expect(subject.id).to eq('https://doi.org/10.5063/f1m61h5x')
      expect(subject.url).to eq('https://github.com/DataONEorg/rdataone')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'NCEAS' }],
                                        'familyName' => 'Jones',
                                        'givenName' => 'Matt',
                                        'id' => 'https://orcid.org/0000-0003-0077-4738',
                                        'type' => 'Person' },
                                      { 'affiliation' => [{ 'name' => 'NCEAS' }],
                                        'familyName' => 'Slaughter',
                                        'givenName' => 'Peter',
                                        'id' => 'https://orcid.org/0000-0002-2192-403X',
                                        'type' => 'Person' },
                                      { 'name' => 'University of California, Santa Barbara',
                                        'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'R Interface to the DataONE REST API' }])
      expect(subject.descriptions.first['description']).to start_with('Provides read and write access to data and metadata')
      expect(subject.subjects).to eq([{ 'subject' => 'data sharing' }, { 'subject' => 'data repository' },
                                      { 'subject' => 'dataone' }])
      expect(subject.version).to eq('2.0.0')
      expect(subject.date).to eq('created' => '2016-05-27',
                                 'published' => '2016-05-27',
                                 'updated' => '2016-05-27')
      expect(subject.publisher).to eq('name' => 'https://cran.r-project.org')
      expect(subject.license).to eq('id' => 'Apache-2.0',
                                    'url' => 'http://www.apache.org/licenses/LICENSE-2.0')
    end

    it 'maremma' do
      input = "#{fixture_path}maremma/codemeta.json"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(subject.url).to eq('https://github.com/datacite/maremma')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'DataCite' }],
                                        'familyName' => 'Fenner',
                                        'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-0077-4738',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Maremma: a Ruby library for simplified network calls' }])
      expect(subject.descriptions.first['description']).to start_with('Simplifies network calls')
      expect(subject.subjects).to eq([{ 'subject' => 'faraday' }, { 'subject' => 'excon' },
                                      { 'subject' => 'net/http' }])
      expect(subject.date).to eq('created' => '2015-11-28',
                                 'published' => '2017-02-24',
                                 'updated' => '2017-02-24')
      expect(subject.publisher).to eq('name' => 'DataCite')
      expect(subject.license).to eq('id' => 'MIT', 'url' => 'https://opensource.org/licenses/MIT')
    end

    it 'metadata_reports' do
      input = 'https://github.com/datacite/metadata-reports/blob/master/software/codemeta.json'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5438/wr0x-e194')
      expect(subject.url).to eq('https://github.com/datacite/metadata-reports')
      expect(subject.type).to eq('Software')
      expect(subject.creators.size).to eq(4)
      expect(subject.creators.last).to eq('familyName' => 'Nielsen', 'givenName' => 'Lars Holm',
                                          'id' => 'https://orcid.org/0000-0001-8135-3489',
                                          'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'DOI Registrations for Software' }])
      expect(subject.descriptions.first['description']).to start_with('Analysis of DataCite DOIs registered for software')
      expect(subject.subjects).to eq([{ 'subject' => 'doi' }, { 'subject' => 'software' },
                                      { 'subject' => 'codemeta' }])
      expect(subject.date).to eq('created' => '2018-03-09',
                                 'published' => '2018-05-17',
                                 'updated' => '2018-05-17')
      expect(subject.publisher).to eq('name' => 'DataCite')
      expect(subject.license).to eq('id' => 'MIT', 'url' => 'https://opensource.org/licenses/MIT')
    end
  end
end
