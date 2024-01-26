# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { "#{fixture_path}commonmeta.json" }

  context 'read commonmeta metadata' do
    it "default" do
      expect(subject.valid?).to be true
      expect(subject.schema_version).to eq("https://commonmeta.org/commonmeta_v0.10")
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.type).to eq("JournalArticle")
      expect(subject.url).to eq("https://elifesciences.org/articles/01567")
      expect(subject.contributors.length).to eq(5)
      expect(subject.contributors.first).to eq("type" => "Person", "contributorRoles" => ["Author"],
                                               "givenName" => "Martial", "familyName" => "Sankar", "affiliation" => [{ "name" => "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland" }])
      expect(subject.license).to eq("id" => "CC-BY-3.0",
                                    "url" => "https://creativecommons.org/licenses/by/3.0/legalcode")
      expect(subject.titles).to eq([{ "title" => "Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth" }])
      expect(subject.date).to eq("published" => "2014-02-11", "updated" => "2022-03-26")
      expect(subject.publisher).to eq("id" => "https://api.crossref.org/members/4374",
                                      "name" => "eLife Sciences Publications, Ltd")
      expect(subject.container).to eq("identifier" => "2050-084X",
                                      "identifierType" => "ISSN", "title" => "eLife", "type" => "Journal", "volume" => "3")
      expect(subject.references.length).to eq(27)
      expect(subject.references.last).to eq("containerTitle" => "Nature Cell Biology",
                                            "contributor" => "Yin",
                                            "doi" => "https://doi.org/10.1038/ncb2764",
                                            "firstPage" => "860",
                                            "key" => "bib27",
                                            "publicationYear" => "2013",
                                            "title" => "A screen for morphological complexity identifies regulators of switch-like transitions between discrete cell shapes",
                                            "volume" => "15")
      expect(subject.funding_references).to eq([{ "funderName" => "SystemsX" },
                                                { "funderName" => "EMBO longterm post-doctoral fellowships" },
                                                { "funderName" => "Marie Heim-Voegtlin" },
                                                { "funderIdentifier" => "https://doi.org/10.13039/501100006390",
                                                  "funderIdentifierType" => "Crossref Funder ID",
                                                  "funderName" => "University of Lausanne" },
                                                { "funderName" => "SystemsX" },
                                                { "funderIdentifier" => "https://doi.org/10.13039/501100003043",
                                                  "funderIdentifierType" => "Crossref Funder ID",
                                                  "funderName" => "EMBO" },
                                                { "funderIdentifier" => "https://doi.org/10.13039/501100001711",
                                                  "funderIdentifierType" => "Crossref Funder ID",
                                                  "funderName" => "Swiss National Science Foundation" },
                                                { "funderIdentifier" => "https://doi.org/10.13039/501100006390",
                                                  "funderIdentifierType" => "Crossref Funder ID",
                                                  "funderName" => "University of Lausanne" }])
      expect(subject.provider).to eq("Crossref")
    end
  end
end
