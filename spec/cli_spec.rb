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
    DEPOSITOR_REGEX = /<depositor_name>test<\/depositor_name>/
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

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml", depositor: "test", email: "info@example.org", registrant: "test" }
        expect { subject.convert id }.to output(CROSSREF_XML_REGEX).to_stdout
        expect { subject.convert id }.to output(DEPOSITOR_REGEX).to_stdout
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

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml", depositor: "test", email: "info@example.org", registrant: "test" }
        expect { subject.convert file }.to output(CROSSREF_XML_REGEX).to_stdout
        expect { subject.convert file }.to output(DEPOSITOR_REGEX).to_stdout
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
        subject.options = { to: "crossref_xml", depositor: "test", email: "info@example.org", registrant: "test" }
        expect { subject.convert file }.to output(CROSSREF_XML_REGEX).to_stdout
        expect { subject.convert file }.to output(DEPOSITOR_REGEX).to_stdout
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

      it 'to crossref_xml' do
        subject.options = { to: "crossref_xml", depositor: "test", email: "info@example.org", registrant: "test" }
        expect { subject.convert file }.to output(CROSSREF_XML_REGEX).to_stdout
        expect { subject.convert file }.to output(DEPOSITOR_REGEX).to_stdout
      end

      it 'to datacite invalid' do
        file = fixture_path + "datacite_missing_creator.xml"
        subject.options = { to: "datacite", show_errors: "true" }
        expect { subject.convert file }.to output(/root is missing required keys: id, type, url, contributors, titles, publisher, date/).to_stderr
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

  describe "encode", vcr: true do
    it "valid doi prefix" do
      input = "10.53731"
      expect { subject.encode input }.to output(/https:\/\/doi.org\/10.53731/).to_stdout
    end

    it "invalid doi prefix" do
      input = "11.1234"
      expect { subject.encode input }.to output("").to_stdout
    end

    it "by_blog" do
      input = "iphylo"
      expect { subject.encode_by_blog input }.to output(/https:\/\/doi.org\/10.59350/).to_stdout
    end

    it "by_blog unknown blog_id" do
      input = "iballo"
      expect { subject.encode_by_blog input }.to output("").to_stdout
    end

    it "by_id" do
      input = "2b22bbba-bcba-4072-94cc-3f88442fff88"
      expect { subject.encode_by_id input }.to output(/https:\/\/doi.org\/10.54900/).to_stdout
    end

    it "by_id unknown uuid" do
      input = "2b22bbba-bcba-4072-94cc-3f88442"
      expect { subject.encode_by_id input }.to output("").to_stdout
    end
  end

  describe "decode" do
    let(:input) { "10.53731/cjx855h-hn5jtq8" }

    it "blog post" do
      expect { subject.decode input }.to output(/464528469187255429864\n/).to_stdout
    end
  end

  describe "encode_id" do
    it "random" do
      expect { subject.encode_id }.to output(/[a-z0-9]+/).to_stdout
    end
  end

  describe "decode_id" do
    let(:input) { "h49ct36" }

    it "blog post" do
      expect { subject.decode_id input }.to output(/18397685862\n/).to_stdout
    end
  end

  describe "json_feed", vcr: true do
    it "json_feed_unregistered" do
      expect { subject.json_feed_unregistered }.to output(/17d0e31c-bc41-42b8-b873-d3dacee61f5c/).to_stdout
    end
    
    # it "json_feed_not_indexed" do
    #   expect { subject.json_feed_not_indexed }.to output(/r294649-6f79289-8cw1w/).to_stdout
    # end

    it "json_feed_by_blog" do
      input = "iphylo"
      expect { subject.json_feed_by_blog input }.to output(/3749f8c4-1ba7-4e51-9dd6-9d9551ad451a/).to_stdout
    end

    it "json_feed_blog_id" do
      input = "01a92f9a-f8e0-442b-86e2-11530d9d5635"
      expect { subject.json_feed_blog_id input }.to output(/eve/).to_stdout
    end
  end
end
