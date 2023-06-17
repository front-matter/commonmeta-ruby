# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { 'https://github.com/citation-file-format/ruby-cff/blob/main/CITATION.cff' }

  context 'get cff metadata' do
    it 'ruby-cff' do
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1184077')
      expect(subject.url).to eq('https://github.com/citation-file-format/ruby-cff')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'The University of Manchester, UK' }], 'familyName' => 'Haines', 'givenName' => 'Robert',
                                        'id' => 'https://orcid.org/0000-0002-9538-7919',
                                        'type' => 'Person' },
                                      { 'name' => 'The Ruby Citation File Format Developers',
                                        'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'Ruby CFF Library' }])
      expect(subject.descriptions.first['description']).to start_with('This library provides a Ruby interface to manipulate Citation File Format files')
      expect(subject.subjects).to eq([{ 'subject' => 'Ruby' },
                                      { 'subject' => 'Credit' },
                                      { 'subject' => 'Software citation' },
                                      { 'subject' => 'Research software' },
                                      { 'subject' => 'Software sustainability' },
                                      { 'subject' => 'Metadata' },
                                      { 'subject' => 'Citation file format' },
                                      { 'subject' => 'Cff' }])
      expect(subject.version).to eq('1.0.1')
      expect(subject.date).to eq('published' => '2022-11-05')
      expect(subject.publisher).to eq('name' => 'GitHub')
      expect(subject.license).to eq('id' => 'Apache-2.0',
                                    'url' => 'http://www.apache.org/licenses/LICENSE-2.0')
      expect(subject.references).to eq([{ 'doi' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'key' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'publicationYear' => '2021' }])
    end

    it 'cff-converter-python' do
      input = 'https://github.com/citation-file-format/cff-converter-python/blob/main/CITATION.cff'
      subject = described_class.new(input: input)
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1162057')
      expect(subject.url).to eq('https://github.com/citation-file-format/cff-converter-python')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'Netherlands eScience Center' }],
                                        'familyName' => 'Spaaks',
                                        'givenName' => 'Jurriaan H.',
                                        'id' => 'https://orcid.org/0000-0002-7064-4069',
                                        'type' => 'Person' },
                                      { 'affiliation' => [{ 'name' => 'Netherlands eScience Center' }],
                                        'familyName' => 'Klaver',
                                        'givenName' => 'Tom',
                                        'type' => 'Person' },
                                      { 'affiliation' => [{ 'name' => 'Netherlands eScience Center' }],
                                        'familyName' => 'Verhoeven',
                                        'id' => 'https://orcid.org/0000-0002-5821-2060',
                                        'givenName' => 'Stefan',
                                        'type' => 'Person' },
                                      { 'affiliation' => [{ 'name' => 'Humboldt-Universität zu Berlin' }],
                                        'familyName' => 'Druskat',
                                        'givenName' => 'Stephan',
                                        'id' => 'https://orcid.org/0000-0003-4925-7248',
                                        'type' => 'Person' },
                                      { 'affiliation' => [{ 'name' => 'University of Oslo' }],
                                        'familyName' => 'Leoncio',
                                        'givenName' => 'Waldir',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'cffconvert' }])
      expect(subject.descriptions.first['description']).to start_with('Command line program to validate and convert CITATION.cff files')
      expect(subject.subjects).to eq([{ 'subject' => 'Bibliography' },
                                      { 'subject' => 'Bibtex' },
                                      { 'subject' => 'Cff' },
                                      { 'subject' => 'Citation' },
                                      { 'subject' => 'Citation.cff' },
                                      { 'subject' => 'Codemeta' },
                                      { 'subject' => 'Endnote' },
                                      { 'subject' => 'Ris' },
                                      { 'subject' => 'Citation file format' }])
      expect(subject.version).to eq('2.0.0')
      expect(subject.date).to eq('published' => '2021-09-22')
      expect(subject.publisher).to eq('name' => 'GitHub')
      expect(subject.license).to eq('id' => 'Apache-2.0', 'url' => 'http://www.apache.org/licenses/LICENSE-2.0')
      expect(subject.references).to eq([{ 'doi' => 'https://doi.org/10.5281/zenodo.1310751',
                                          'key' => 'https://doi.org/10.5281/zenodo.1310751',
                                          'publicationYear' => '2018' },
                                        { 'key' => 'https://blog.apastyle.org/apastyle/2015/01/how-to-cite-software-in-apa-style.html',
                                          'url' => 'https://blog.apastyle.org/apastyle/2015/01/how-to-cite-software-in-apa-style.html' }])
    end

    it 'ruby-cff' do
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1184077')
      expect(subject.url).to eq('https://github.com/citation-file-format/ruby-cff')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'The University of Manchester, UK' }], 'familyName' => 'Haines', 'givenName' => 'Robert',
                                        'id' => 'https://orcid.org/0000-0002-9538-7919', 'type' => 'Person' }, { 'name' => 'The Ruby Citation File Format Developers', 'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'Ruby CFF Library' }])
      expect(subject.descriptions.first['description']).to start_with('This library provides a Ruby interface to manipulate Citation File Format files')
      expect(subject.subjects).to eq([{ 'subject' => 'Ruby' },
                                      { 'subject' => 'Credit' },
                                      { 'subject' => 'Software citation' },
                                      { 'subject' => 'Research software' },
                                      { 'subject' => 'Software sustainability' },
                                      { 'subject' => 'Metadata' },
                                      { 'subject' => 'Citation file format' },
                                      { 'subject' => 'Cff' }])
      expect(subject.version).to eq('1.0.1')
      expect(subject.date).to eq('published' => '2022-11-05')
      expect(subject.publisher).to eq('name' => 'GitHub')
      expect(subject.license).to eq('id' => 'Apache-2.0',
                                    'url' => 'http://www.apache.org/licenses/LICENSE-2.0')
      expect(subject.references).to eq([{ 'doi' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'key' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'publicationYear' => '2021' }])
    end

    it 'ruby-cff repository url' do
      input = 'https://github.com/citation-file-format/ruby-cff'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1184077')
      expect(subject.url).to eq('https://github.com/citation-file-format/ruby-cff')
      expect(subject.type).to eq('Software')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'The University of Manchester, UK' }], 'familyName' => 'Haines', 'givenName' => 'Robert',
                                        'id' => 'https://orcid.org/0000-0002-9538-7919', 'type' => 'Person' }, { 'name' => 'The Ruby Citation File Format Developers', 'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'Ruby CFF Library' }])
      expect(subject.descriptions.first['description']).to start_with('This library provides a Ruby interface to manipulate Citation File Format files')
      expect(subject.subjects).to eq([{ 'subject' => 'Ruby' },
                                      { 'subject' => 'Credit' },
                                      { 'subject' => 'Software citation' },
                                      { 'subject' => 'Research software' },
                                      { 'subject' => 'Software sustainability' },
                                      { 'subject' => 'Metadata' },
                                      { 'subject' => 'Citation file format' },
                                      { 'subject' => 'Cff' }])
      expect(subject.version).to eq('1.0.1')
      expect(subject.date).to eq('published' => '2022-11-05')
      expect(subject.publisher).to eq('name' => 'GitHub')
      expect(subject.license).to eq('id' => 'Apache-2.0',
                                    'url' => 'http://www.apache.org/licenses/LICENSE-2.0')
      expect(subject.references).to eq([{ 'doi' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'key' => 'https://doi.org/10.5281/zenodo.1003149',
                                          'publicationYear' => '2021' }])
    end
  end
end
