# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { 'http://doi.org/10.5438/4K3M-NYVG' }

  context 'handle input' do
    it 'unknown DOI prefix' do
      input = 'http://doi.org/10.0137/14802'
      subject = described_class.new(input: input)
      expect(subject.errors).to eq(["root is missing required keys: id, creators, titles, publisher, publication_year, types"])
      expect(subject.valid?).to be false
      expect(subject.bibtex.nil?).to be(true)
    end

    it 'DOI RA not Crossref or DataCite' do
      input = 'http://doi.org/10.3980/j.issn.2222-3959.2015.03.07'
      subject = described_class.new(input: input)
      expect(subject.errors).to eq(["root is missing required keys: id, creators, titles, publisher, publication_year, types"])
      expect(subject.valid?).to be false
      expect(subject.bibtex.nil?).to be(true)
    end
  end

  context 'find from format by ID' do
    it 'crossref' do
      id = 'https://doi.org/10.1371/journal.pone.0000030'
      expect(subject.find_from_format(id: id)).to eq('crossref')
    end

    it 'crossref doi not url' do
      id = '10.1371/journal.pone.0000030'
      expect(subject.find_from_format(id: id)).to eq('crossref')
    end

    it 'datacite' do
      id = 'https://doi.org/10.5438/4K3M-NYVG'
      expect(subject.find_from_format(id: id)).to eq('datacite')
    end

    it 'datacite doi http' do
      id = 'http://doi.org/10.5438/4K3M-NYVG'
      expect(subject.find_from_format(id: id)).to eq('datacite')
    end

    it 'unknown DOI registration agency' do
      id = 'http://doi.org/10.0137/14802'
      expect(subject.find_from_format(id: id).nil?).to be(true)
    end

    it 'orcid' do
      id = 'http://orcid.org/0000-0002-0159-2197'
      expect(subject.find_from_format(id: id)).to eq('orcid')
    end

    it 'github' do
      id = 'https://github.com/datacite/maremma/blob/master/codemeta.json'
      expect(subject.find_from_format(id: id)).to eq('codemeta')
    end

    it 'schema_org' do
      id = 'https://blog.datacite.org/eating-your-own-dog-food'
      expect(subject.find_from_format(id: id)).to eq('schema_org')
    end
  end

  context 'find from format from file' do
    it 'bibtex' do
      file = "#{fixture_path}crossref.bib"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('bibtex')
    end

    it 'ris' do
      file = "#{fixture_path}crossref.ris"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('ris')
    end

    it 'crossref' do
      file = "#{fixture_path}crossref.xml"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('crossref')
    end

    it 'crossref_json' do
      file = "#{fixture_path}crossref.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('crossref_json')
    end


    it 'datacite' do
      file = "#{fixture_path}datacite.xml"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('datacite')
    end

    it 'datacite_json' do
      file = "#{fixture_path}datacite.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('datacite_json')
    end

    it 'schema_org' do
      file = "#{fixture_path}schema_org.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('schema_org')
    end

    it 'citeproc' do
      file = "#{fixture_path}citeproc.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('citeproc')
    end

    it 'crosscite' do
      file = "#{fixture_path}crosscite.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('crosscite')
    end

    it 'codemeta' do
      file = "#{fixture_path}codemeta.json"
      string = File.read(file)
      ext = File.extname(file)
      expect(subject.find_from_format(string: string, ext: ext)).to eq('codemeta')
    end
  end

  context 'find from format from string' do
    it 'crosscite' do
      file = "#{fixture_path}crosscite.json"
      string = File.read(file)
      expect(subject.find_from_format(string: string)).to eq('crosscite')
    end

    it 'crossref' do
      file = "#{fixture_path}crossref.xml"
      string = File.read(file)
      expect(subject.find_from_format(string: string)).to eq('crossref')
    end

    it 'crossref_json' do
      file = "#{fixture_path}crossref.json"
      string = File.read(file)
      expect(subject.find_from_format(string: string)).to eq('crossref_json')
    end

    it 'datacite' do
      file = "#{fixture_path}datacite.xml"
      string = File.read(file)
      expect(subject.find_from_format(string: string)).to eq('datacite')
    end
  end

  context 'jsonlint' do
    it 'valid' do
      json = File.read("#{fixture_path}datacite_software.json")
      response = subject.jsonlint(json)
      expect(response.empty?).to be(true)
    end

    it 'nil' do
      json = nil
      response = subject.jsonlint(json)
      expect(response).to eq(['No JSON provided'])
    end

    it 'missing_comma' do
      json = File.read("#{fixture_path}datacite_software_missing_comma.json")
      response = subject.jsonlint(json)
      expect(response).to eq(['expected comma, not a string (after doi) at line 4, column 11 [parse.c:430]'])
    end

    it 'overlapping_keys' do
      json = File.read("#{fixture_path}datacite_software_overlapping_keys.json")
      response = subject.jsonlint(json)
      expect(response).to eq(['The same key is defined more than once: id'])
    end
  end
end
