# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::CLI do
  context 'find_from_format_by_id', vcr: true do
    let(:subject) do
      described_class.new
    end

    it 'crossref' do
      id = 'https://doi.org/10.7554/eLife.01567'
      expect(subject.find_from_format_by_id(id)).to eq('crossref')
    end

    it 'datacite' do
      id = 'https://doi.org/10.5061/DRYAD.8515'
      expect(subject.find_from_format_by_id(id)).to eq('datacite')
    end

    it 'medra' do
      id = 'https://doi.org/10.1392/roma081203'
      expect(subject.find_from_format_by_id(id)).to eq('medra')
    end

    it 'kisti' do
      id = 'https://doi.org/10.5012/bkcs.2013.34.10.2889'
      expect(subject.find_from_format_by_id(id)).to eq('kisti')
    end

    it 'jalc' do
      id = 'https://doi.org/10.11367/grsj1979.12.283'
      expect(subject.find_from_format_by_id(id)).to eq('jalc')
    end

    it 'op' do
      id = 'https://doi.org/10.2791/81962'
      expect(subject.find_from_format_by_id(id)).to eq('op')
    end

    it 'cff' do
      id = 'https://github.com/citation-file-format/ruby-cff/blob/main/CITATION.cff'
      expect(subject.find_from_format_by_id(id)).to eq('cff')
    end

    it 'cff repository url' do
      id = 'https://github.com/citation-file-format/ruby-cff'
      expect(subject.find_from_format_by_id(id)).to eq('cff')
    end

    it 'codemeta' do
      id = 'https://github.com/datacite/maremma/blob/master/codemeta.json'
      expect(subject.find_from_format_by_id(id)).to eq('codemeta')
    end

    it 'npm' do
      id = 'https://github.com/datacite/bracco/blob/master/package.json'
      expect(subject.find_from_format_by_id(id)).to eq('npm')
    end

    it 'schema_org' do
      id = 'https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/GAOC03'
      expect(subject.find_from_format_by_id(id)).to eq('schema_org')
    end
  end

  context 'find_from_format_by_filename' do
    let(:subject) do
      described_class.new
    end

    it 'npm' do
      filename = 'package.json'
      expect(subject.find_from_format_by_filename(filename)).to eq('npm')
    end

    it 'cff' do
      filename = 'CITATION.cff'
      expect(subject.find_from_format_by_filename(filename)).to eq('cff')
    end
  end

  context 'find_from_format_by_ext' do
    let(:subject) do
      described_class.new
    end

    it 'bibtex' do
      string = File.read("#{fixture_path}crossref.bib").strip
      expect(subject.find_from_format_by_ext(string, ext: '.bib')).to eq('bibtex')
    end

    it 'ris' do
      string = File.read("#{fixture_path}crossref.ris").strip
      expect(subject.find_from_format_by_ext(string, ext: '.ris')).to eq('ris')
    end
  end

  context 'find_from_format_by_string' do
    let(:subject) do
      described_class.new
    end

    it 'crossref_xml' do
      string = File.read("#{fixture_path}crossref.xml").strip
      expect(subject.find_from_format_by_string(string)).to eq('crossref_xml')
    end

    it 'crossref' do
      string = File.read("#{fixture_path}crossref.json").strip
      expect(subject.find_from_format_by_string(string)).to eq('crossref')
    end

    it 'codemeta' do
      string = File.read("#{fixture_path}codemeta.json").strip
      expect(subject.find_from_format_by_string(string)).to eq('codemeta')
    end

    it 'cff' do
      string = File.read("#{fixture_path}CITATION.cff").strip
      expect(subject.find_from_format_by_string(string)).to eq('cff')
    end

    it 'schema_org' do
      string = File.read("#{fixture_path}schema_org_topmed.json").strip
      expect(subject.find_from_format_by_string(string)).to eq('schema_org')
    end

    it 'ris' do
      string = File.read("#{fixture_path}crossref.ris").strip
      expect(subject.find_from_format_by_string(string)).to eq('ris')
    end

    it 'ris from pure' do
      string = File.read("#{fixture_path}pure.ris").strip
      expect(subject.find_from_format_by_string(string)).to eq('ris')
    end

    it 'bibtex' do
      string = File.read("#{fixture_path}crossref.bib").strip
      expect(subject.find_from_format_by_string(string)).to eq('bibtex')
    end
  end
end
