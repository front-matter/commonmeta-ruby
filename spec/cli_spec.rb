# frozen_string_literal: true

require 'spec_helper'
require 'commonmeta/cli'

describe Commonmeta::CLI do
  let(:subject) do
    described_class.new
  end

  describe "convert from id", vcr: true do
    SCHEMA_ORG_REGEX = /"@context": "http:\/\/schema.org"/
    CROSSREF_XML_REGEX = /<doi_batch/
    DATACITE_REGEX = /"types": {/
    BIBTEX_REGEX = /@article{https:\/\/doi.org\/10.7554\/elife.01567/
    BIBTEX_DATA_REGEX = /@misc{https:\/\/doi.org\/10.5061\/dryad.8515/
    RIS_REGEX = /TY  - JOUR/
    CSL_REGEX = 'type: "article-journal'
    CITATION_REGEX = /Sankar M, Nieminen K, Ragni L, Xenarios I/
    CITATION_DATA_REGEX = /Ollomo B, Durand P, Prugnolle F/
    JATS_REGEX = /article-title/

    context "crossref" do
      let(:input) { "10.7554/eLife.01567" }

      it 'default' do
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { from: "crossref", to: "schema_org" }
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to crossref_xml' do
        subject.options = { from: "crossref", to: "crossref_xml" }
        expect { subject.convert input }.to output(CROSSREF_XML_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { from: "crossref", to: "datacite" }
        expect { subject.convert input }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { from: "crossref", to: "bibtex" }
        expect { subject.convert input }.to output(BIBTEX_REGEX).to_stdout
      end

      it 'to citation' do
        subject.options = { from: "crossref", to: "citation", style: "vancouver" }
        expect { subject.convert input }.to output(CITATION_REGEX).to_stdout
      end
    end

    context "crossref" do
      let(:input) { "10.7554/eLife.01567" }

      it 'default' do
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml" }
        expect { subject.convert input }.to output(CROSSREF_XML_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert input }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert input }.to output(BIBTEX_REGEX).to_stdout
      end

      it 'to citation' do
        subject.options = { to: "citation", style: "vancouver" }
        expect { subject.convert input }.to output(CITATION_REGEX).to_stdout
      end

      it 'to jats' do
        subject.options = { to: "jats" }
        expect { subject.convert input }.to output(JATS_REGEX).to_stdout
      end
    end

    context "datacite" do
      let(:input) { "10.5061/dryad.8515" }

      it 'default' do
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert input }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert input }.to output(BIBTEX_DATA_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert input }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to citation' do
        subject.options = { to: "citation", style: "vancouver" }
        expect { subject.convert input }.to output(CITATION_DATA_REGEX).to_stdout
      end

      it 'to jats' do
        subject.options = { to: "jats" }
        expect { subject.convert input }.to output(/data-title/).to_stdout
      end
    end

    context "schema_org" do
      let(:id) { "https://blog.datacite.org/eating-your-own-dog-food" }

      it 'default' do
        expect { subject.convert id }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert id }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert id }.to output(DATACITE_REGEX).to_stdout
      end

      # TODO
      # it 'to bibtex' do
      #   subject.options = { to: "bibtex" }
      #   expect { subject.convert id }.to output(/@article{https:\/\/doi.org\/10.5438\/4k3m-nyvg/).to_stdout
      # end
    end
  end

  describe "convert file" do
    context "bibtex" do
      let(:file) { fixture_path + "crossref.bib" }

      it 'default' do
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end
    end

    context "crossref_xml", vcr: true do
      let(:file) { fixture_path + "crossref.xml" }

      it 'default' do
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml" }
        expect { subject.convert file }.to output(CROSSREF_XML_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert file }.to output(BIBTEX_REGEX).to_stdout
      end
    end

    context "crossref", vcr: true do
      let(:file) { fixture_path + "crossref.json" }

      it 'default' do
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml" }
        expect { subject.convert file }.to output(CROSSREF_XML_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert file }.to output(BIBTEX_REGEX).to_stdout
      end
    end

    context "datacite", vcr: true do
      let(:file) { fixture_path + "datacite.json" }

      it 'default' do
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert file }.to output(/@article{https:\/\/doi.org\/10.5438\/4k3m-nyvg/).to_stdout
      end

      it 'to datacite invalid' do
        file = fixture_path + "datacite_missing_creator.xml"
        subject.options = { to: "datacite", show_errors: "true" }
        expect { subject.convert file }.to output(/root is missing required keys: id, type, url, creators, titles, publisher, date/).to_stderr
      end

      it 'to datacite invalid ignore errors' do
        file = fixture_path + "datacite_missing_creator.xml"
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end
    end

    context "codemeta" do
      let(:file) { fixture_path + "codemeta.json" }

      it 'default' do
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to schema_org' do
        subject.options = { to: "schema_org" }
        expect { subject.convert file }.to output(SCHEMA_ORG_REGEX).to_stdout
      end

      it 'to datacite' do
        subject.options = { to: "datacite" }
        expect { subject.convert file }.to output(DATACITE_REGEX).to_stdout
      end

      it 'to bibtex' do
        subject.options = { to: "bibtex" }
        expect { subject.convert file }.to output(/@misc{https:\/\/doi.org\/10.5063\/f1m61h5x/).to_stdout
      end
    end

    # context "unsupported format" do
    #   let(:file) { fixture_path + "crossref.xxx" }
    #
    #   it 'error' do
    #     expect { subject.convert file }.to output(/datePublished/).to_stderr
    #   end
    # end
  end

  describe "encode" do
    let(:input) { "10.53731" }

    it "blog prefix" do
      expect { subject.encode input }.to output(/https:\/\/doi.org\/10.53731/).to_stdout
    end
  end

  describe "decode" do
    let(:input) { "10.53731/cjx855h-hn5jtq8" }

    it "blog post" do
      expect { subject.decode input }.to output(/464528469187255429864\n/).to_stdout
    end
  end
end
