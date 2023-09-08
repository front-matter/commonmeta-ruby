# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input, from: "npm") }

  let(:input) { "#{fixture_path}cgimp_package.json" }

  context "get npm raw" do
    it "software" do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context "get npm metadata" do
    it "minimal" do
      expect(subject.valid?).to be false
      expect(subject.errors.first).to eq("root is missing required keys: id, url, publisher, date")
      # expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}])
      # expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Software")
      expect(subject.contributors).to be_empty
      expect(subject.titles).to eq([{ "title" => "fullstack_app" }])
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.license).to eq("id" => "ISC",
                                    "url" => "https://www.isc.org/downloads/software-support-policy/isc-license/")
      expect(subject.version).to eq("1.0.0")
      # expect(subject.dates).to eq([{"date"=>"2016-12-20", "dateType"=>"Issued"}])
      # expect(subject.publication_year).to eq("2016")
    end

    it "minimal with description" do
      input = "#{fixture_path}cit_package.json"
      subject = described_class.new(input: input, from: "npm")
      expect(subject.valid?).to be false
      expect(subject.errors.first).to eq("root is missing required keys: id, url, publisher, date")
      # expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}])
      # expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Software")
      expect(subject.contributors).to be_empty
      expect(subject.titles).to eq([{ "title" => "CITapp" }])
      expect(subject.descriptions).to eq([{ "description" => "Concealed Information Test app",
                                            "descriptionType" => "Abstract" }])
      expect(subject.version).to eq("1.1.0")
      # expect(subject.dates).to eq([{"date"=>"2016-12-20", "dateType"=>"Issued"}])
      # expect(subject.publication_year).to eq("2016")
    end

    it "minimal with description" do
      input = "#{fixture_path}edam_package.json"
      subject = described_class.new(input: input, from: "npm")
      expect(subject.valid?).to be false
      expect(subject.errors.first).to eq("root is missing required keys: id, url, publisher, date")
      # expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}])
      # expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Software")
      expect(subject.contributors).to eq([{ "familyName" => "Brancotte", "givenName" => "Bryan",
                                            "type" => "Person", "contributorRoles" => ["Author"] }])
      expect(subject.titles).to eq([{ "title" => "edam-browser" }])
      expect(subject.descriptions).to eq([{ "description" => +"The EDAM Browser is a client-side web-based visualization javascript widget. Its goals are to help describing bio-related resources and service with EDAM, and to facilitate and foster community contributions to EDAM.",
                                            "descriptionType" => "Abstract" }])
      expect(subject.version).to eq("1.0.0")
      # expect(subject.dates).to eq([{"date"=>"2016-12-20", "dateType"=>"Issued"}])
      # expect(subject.publication_year).to eq("2016")
    end
  end
end
