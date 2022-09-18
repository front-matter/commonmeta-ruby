# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context 'write metadata as rdf xml' do
    it 'journal article' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('ScholarlyArticle', 'rdf:about')).to eq('https://doi.org/10.7554/elife.01567')
      expect(rdf_xml.dig('ScholarlyArticle',
                         'name')).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(rdf_xml.dig('ScholarlyArticle', 'datePublished', '__content__')).to eq('2014-02-11')
    end

    it 'with pages' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('ScholarlyArticle', 'rdf:about')).to eq('https://doi.org/10.1155/2012/291294')
      expect(rdf_xml.dig('ScholarlyArticle',
                         'name')).to eq('Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers')
      expect(rdf_xml.dig('ScholarlyArticle', 'datePublished', '__content__')).to eq('2012')
      expect(rdf_xml.dig('ScholarlyArticle', 'pageStart')).to eq('1')
      expect(rdf_xml.dig('ScholarlyArticle', 'pageEnd')).to eq('7')
    end

    it 'Crossref DOI' do
      input = "#{fixture_path}crossref.bib"
      subject = described_class.new(input: input, from: 'bibtex')
      expect(subject.valid?).to be true
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})

      expect(rdf_xml.dig('ScholarlyArticle', 'rdf:about')).to eq('https://doi.org/10.7554/elife.01567')
      expect(rdf_xml.dig('ScholarlyArticle',
                         'name')).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(rdf_xml.dig('ScholarlyArticle', 'datePublished', '__content__')).to eq('2014')
      expect(rdf_xml.dig('ScholarlyArticle', 'periodical', 'Journal', 'name')).to eq('eLife')
    end

    it 'BlogPosting' do
      input = 'https://doi.org/10.5438/4K3M-NYVG'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('ScholarlyArticle', 'rdf:about')).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(rdf_xml.dig('ScholarlyArticle', 'name')).to eq('Eating your own Dog Food')
      expect(rdf_xml.dig('ScholarlyArticle',
                         'keywords')).to eq('datacite, doi, metadata, FOS: Computer and information sciences')
      expect(rdf_xml.dig('ScholarlyArticle', 'datePublished', '__content__')).to eq('2016-12-20')
    end

    it 'BlogPosting Citeproc JSON' do
      input = "#{fixture_path}citeproc.json"
      subject = described_class.new(input: input, from: 'citeproc')
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('BlogPosting', 'rdf:about')).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(rdf_xml.dig('BlogPosting', 'name')).to eq('Eating your own Dog Food')
      expect(rdf_xml.dig('BlogPosting', 'datePublished', '__content__')).to eq('2016-12-20')
    end

    it 'maremma' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('SoftwareSourceCode', 'rdf:about')).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(rdf_xml.dig('SoftwareSourceCode', 'author', 'Person', 'rdf:about')).to eq('https://orcid.org/0000-0003-0077-4738')
      expect(rdf_xml.dig('SoftwareSourceCode', 'author', 'Person', 'name')).to eq('Martin Fenner')
      expect(rdf_xml.dig('SoftwareSourceCode',
                         'name')).to eq('Maremma: a Ruby library for simplified network calls')
      expect(rdf_xml.dig('SoftwareSourceCode', 'keywords')).to eq('faraday, excon, net/http')
      expect(rdf_xml.dig('SoftwareSourceCode', 'datePublished', '__content__')).to eq('2017-02-24')
    end

    it 'BlogPosting schema.org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food/'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      rdf_xml = Maremma.from_xml(subject.rdf_xml).fetch('RDF', {})
      expect(rdf_xml.dig('Article', 'rdf:about')).to eq('https://doi.org/10.53731/r79vxn1-97aq74v-ag58n')
      expect(rdf_xml.dig('Article', 'author', 'Person', 'rdf:about')).to eq('https://orcid.org/0000-0003-1419-2405')
      expect(rdf_xml.dig('Article', 'author', 'Person', 'name')).to eq('Martin Fenner')
      expect(rdf_xml.dig('Article', 'name')).to eq('Eating your own Dog Food')
      expect(rdf_xml.dig('Article', 'keywords')).to eq('feature')
      expect(rdf_xml.dig('Article', 'datePublished', '__content__')).to eq('2016-12-20T00:00:00Z')
    end
  end
end
