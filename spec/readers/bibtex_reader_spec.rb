# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { "#{fixture_path}crossref.bib" }

  context 'detect format' do
    it 'extension' do
      expect(subject.valid?).to be true
    end

    it 'string' do
      described_class.new(input: File.read(input).strip)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567')
    end
  end

  context 'get bibtex raw' do
    it 'Crossref DOI' do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context 'get bibtex metadata' do
    it 'Crossref DOI' do
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.url).to eq('http://elifesciences.org/lookup/doi/10.7554/eLife.01567')
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq('familyName' => 'Sankar', 'givenName' => 'Martial',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth' }])
      expect(subject.descriptions.first['description']).to start_with('Among various advantages, their small size makes model organisms preferred subjects of investigation.')
      expect(subject.license).to eq('id' => 'CC-BY-3.0', 'url' => 'https://creativecommons.org/licenses/by/3.0/legalcode')
      expect(subject.date).to eq('published' => '2014')
    end

    it 'DOI does not exist' do
      input = "#{fixture_path}pure.bib"
      doi = '10.7554/elife.01567'
      subject = described_class.new(input: input, doi: doi)
      expect(subject.valid?).to be false
      expect(subject.state).to eq('not_found')
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567')
      expect(subject.type).to eq('Dissertation')
      expect(subject.creators).to eq([{ 'familyName' => 'Toparlar', 'givenName' => 'Y.',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'A multiscale analysis of the urban heat island effect: from city averaged temperatures to the energy demand of individual buildings' }])
      expect(subject.descriptions.first['description']).to start_with('Designing the climates of cities')
      expect(subject.date).to eq('published' => '2018')
    end
  end
end
