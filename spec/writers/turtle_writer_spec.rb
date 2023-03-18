# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  context 'write metadata as turtle' do
    it 'Crossref DOI' do
      input = "#{fixture_path}crossref.bib"
      subject = described_class.new(input: input, from: 'bibtex')
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.7554/elife.01567> a schema:ScholarlyArticle;')
    end

    it 'Dataset' do
      input = 'https://doi.org/10.5061/DRYAD.8515'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.5061/dryad.8515> a schema:Dataset;')
    end

    it 'BlogPosting' do
      input = 'https://doi.org/10.5438/4K3M-NYVG'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.5438/4k3m-nyvg> a schema:Article;')
    end

    it 'BlogPosting Citeproc JSON' do
      input = "#{fixture_path}citeproc.json"
      subject = described_class.new(input: input, from: 'csl')
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq("<https://doi.org/10.5438/4k3m-nyvg> a schema:Article;")
    end

    it 'BlogPosting DataCite JSON' do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input, from: 'datacite')
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq("<https://doi.org/10.5438/4k3m-nyvg> a schema:Article;")
    end

    it 'BlogPosting schema.org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food//'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.53731/r79vxn1-97aq74v-ag58n> a schema:Article;')
      expect(ttl[3]).to eq('  schema:author <https://orcid.org/0000-0003-1419-2405>;')
    end

    it 'DataONE' do
      input = "#{fixture_path}codemeta.json"
      subject = described_class.new(input: input, from: 'codemeta')
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.5063/f1m61h5x> a schema:SoftwareSourceCode;')
    end

    it 'journal article' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.7554/elife.01567> a schema:ScholarlyArticle;')
    end

    it 'with pages' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      ttl = subject.turtle.split("\n")
      expect(ttl[0]).to eq('@prefix schema: <http://schema.org/> .')
      expect(ttl[2]).to eq('<https://doi.org/10.1155/2012/291294> a schema:ScholarlyArticle;')
    end
  end
end
