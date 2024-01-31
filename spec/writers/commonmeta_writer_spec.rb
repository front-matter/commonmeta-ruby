# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  context "write metadata as commonmeta" do
    it "with data citation" do
      input = "10.7554/eLife.01567"
      subject = described_class.new(input: input, from: "crossref")
      json = JSON.parse(subject.commonmeta)
      expect(json["id"]).to eq("https://doi.org/10.7554/elife.01567")
      expect(json["type"]).to eq("JournalArticle")
      expect(json["url"]).to eq("https://elifesciences.org/articles/01567")
      expect(json["titles"]).to eq([{ "title" => "Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth" }])
      expect(json["contributors"].length).to eq(5)
      expect(json["contributors"].first).to eq("affiliation" => [{ "name" => "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland" }],
                                               "contributorRoles" => ["Author"],
                                               "familyName" => "Sankar",
                                               "givenName" => "Martial",
                                               "type" => "Person")
      expect(json["container"]).to eq("identifier" => "2050-084X",
                                      "identifierType" => "ISSN",
                                      "title" => "eLife",
                                      "type" => "Journal",
                                      "volume" => "3")
      expect(json["publisher"]).to eq("id" => "https://api.crossref.org/members/4374", "name" => "eLife Sciences Publications, Ltd")
      expect(json["references"].length).to eq(27)
      expect(json["references"].first).to eq("key" => "bib1",
                                             "doi" => "https://doi.org/10.1038/nature02100",
                                             "contributor" => "Bonke",
                                             "title" => "APL regulates vascular tissue identity in Arabidopsis",
                                             "publicationYear" => "2003",
                                             "volume" => "426",
                                             "firstPage" => "181",
                                             "containerTitle" => "Nature")
      expect(json["date"]).to eq("published" => "2014-02-11", "updated" => "2022-03-26")
      expect(json["descriptions"].first["description"]).to start_with("Among various advantages,")
      expect(json["license"]).to eq("id" => "CC-BY-3.0", "url" => "https://creativecommons.org/licenses/by/3.0/legalcode")
      expect(json["provider"]).to eq("Crossref")
      expect(json["files"].first).to eq("mimeType" => "application/pdf", "url" => "https://cdn.elifesciences.org/articles/01567/elife-01567-v1.pdf")
    end

    it "dataset schema v4.5" do
      input = "#{fixture_path}datacite-dataset_v4.5.json"
      subject = described_class.new(input: input)
      expect(subject.id).to eq("https://doi.org/10.82433/b09z-4k37")
      json = JSON.parse(subject.commonmeta)
      expect(json["id"]).to eq("https://doi.org/10.82433/b09z-4k37")
      expect(json["type"]).to eq("Dataset")
      expect(json["titles"]).to eq([{ "language" => "en", "title" => "Example Title" },
                                    { "language" => "en", "title" => "Example Subtitle", "type" => "Subtitle" },
                                    { "language" => "fr",
                                      "title" => "Example TranslatedTitle",
                                      "type" => "TranslatedTitle" },
                                    { "language" => "en",
                                      "title" => "Example AlternativeTitle",
                                      "type" => "AlternativeTitle" }])
      expect(json["descriptions"]).to eq([{ "description" => "Example Abstract", "language" => "en", "type" => "Abstract" },
                                          { "description" => "Example Methods", "language" => "en", "type" => "Methods" },
                                          { "description" => "Example SeriesInformation",
                                            "language" => "en",
                                            "type" => "Other" },
                                          { "description" => "Example TableOfContents", "language" => "en", "type" => "Other" },
                                          { "description" => "Example TechnicalInfo",
                                            "language" => "en",
                                            "type" => "TechnicalInfo" },
                                          { "description" => "Example Other", "language" => "en", "type" => "Other" }])
    end
  end
end
