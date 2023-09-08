# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input, from: "csl") }

  let(:input) { "#{fixture_path}citeproc.json" }

  context "get citeproc raw" do
    it "BlogPosting" do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context "get citeproc metadata" do
    it "BlogPosting" do
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5438/4k3m-nyvg")
      expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Article")
      expect(subject.contributors).to eq([{ "familyName" => "Fenner", "givenName" => "Martin",
                                            "type" => "Person", "contributorRoles" => ["Author"] }])
      expect(subject.titles).to eq([{ "title" => "Eating your own Dog Food" }])
      expect(subject.descriptions.first["description"]).to start_with("Eating your own dog food")
      expect(subject.date).to eq("published" => "2016-12-20")
      expect(subject.license).to be_nil
    end
  end

  context "get citeproc no categories" do
    it "BlogPosting" do
      input = "#{fixture_path}citeproc-no-categories.json"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5072/4k3m-nyvg")
      expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Article")
      expect(subject.contributors).to eq([{ "familyName" => "Fenner", "givenName" => "Martin",
                                            "type" => "Person", "contributorRoles" => ["Author"] }])
      expect(subject.titles).to eq([{ "title" => "Eating your own Dog Food" }])
      expect(subject.descriptions.first["description"]).to start_with("Eating your own dog food")
      expect(subject.date).to eq("published" => "2016-12-20")
    end
  end

  context "get citeproc no author" do
    it "Journal article" do
      input = "#{fixture_path}citeproc-no-author.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5438/4k3m-nyvg")
      expect(subject.url).to eq("https://blog.datacite.org/eating-your-own-dog-food")
      expect(subject.type).to eq("Article")
      expect(subject.contributors).to eq([{ "name" => ":(unav)", "type" => "Organization", "contributorRoles" => ["Author"] }])
      expect(subject.titles).to eq([{ "title" => "Eating your own Dog Food" }])
      expect(subject.descriptions.first["description"]).to start_with("Eating your own dog food")
      expect(subject.date).to eq("published" => "2016-12-20")
    end
  end
end
