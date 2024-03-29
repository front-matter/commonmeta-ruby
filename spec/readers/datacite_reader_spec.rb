# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  context "get datacite raw" do
    it "BlogPosting" do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input)
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context "get datacite metadata" do
    it "BlogPosting" do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.type).to eq("Article")
      expect(subject.contributors).to eq([{ "type" => "Person", "contributorRoles" => ["Author"], "givenName" => "Martin", "familyName" => "Fenner",
                                            "id" => "https://orcid.org/0000-0003-1419-2405" }])
      expect(subject.titles).to eq([{ "title" => "Eating your own Dog Food" }])
      expect(subject.alternate_identifiers).to be_nil
      expect(subject.date).to eq("created" => "2016-12-20",
                                 "published" => "2016-12-20",
                                 "updated" => "2016-12-20")
      expect(subject.references.length).to eq(2)
      expect(subject.references.first).to eq("doi" => "https://doi.org/10.5438/0012",
                                             "key" => "10.5438/0012")
      expect(subject.provider).to eq("DataCite")
    end

    it "SoftwareSourceCode" do
      input = "10.5063/f1m61h5x"
      subject = Commonmeta::Metadata.new(input: input, from: "datacite")
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5063/f1m61h5x")
      expect(subject.type).to eq("Software")
      expect(subject.contributors).to eq([{ "contributorRoles" => ["Author"],
                                            "name" => "Jones, Matthew B.; Slaughter, Peter; Nahf, Rob; Boettiger, Carl ; Jones, Chris; Read, Jordan; Walker, Lauren; Hart, Edmund; Chamberlain, Scott",
                                            "type" => "Organization" }])
      expect(subject.titles).to eq([{ "title" => "dataone: R interface to the DataONE network of data repositories" }])
      expect(subject.date).to eq("created" => "2016-03-12", "published" => "2016", "registered" => "2016-03-12", "updated" => "2020-09-18")
      expect(subject.publisher).to eq("name" => "KNB Data Repository")
      expect(subject.provider).to eq("DataCite")
    end

    it "SoftwareSourceCode missing_comma" do
      input = "#{fixture_path}datacite_software_missing_comma.json"
      subject = described_class.new(input: input, from: "datacite", show_errors: true)
      # expect(subject.valid?).to be false
      expect(subject.errors).to eq(["expected comma, not a string (after doi) at line 4, column 11 [parse.c:416]"])
      expect(subject.codemeta.nil?).to be(true)
    end

    it "SoftwareSourceCode overlapping_keys" do
      input = "#{fixture_path}datacite_software_overlapping_keys.json"
      subject = described_class.new(input: input, from: "datacite", show_errors: true)
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["The same key is defined more than once: id"])
      expect(subject.codemeta.nil?).to be(true)
    end

    it "dissertation" do
      input = "10.3204/desy-2014-01645"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.3204/desy-2014-01645")
      expect(subject.type).to eq("Dissertation")
      expect(subject.contributors.length).to eq(3)
      expect(subject.contributors.first).to eq("type" => "Person", "contributorRoles" => ["Author"],
                                               "givenName" => "Heiko", "familyName" => "Conrad")
      expect(subject.contributors.last).to eq("id" => "https://orcid.org/0000-0002-8633-8234", "type" => "Person", "contributorRoles" => ["Supervision"], "givenName" => "Gerhard", "familyName" => "Gruebel", "affiliation" => [{ "name" => "Deutsches Elektronen-Synchrotron" }])
      expect(subject.titles).to eq([{ "title" => "Dynamics of colloids in molecular glass forming liquids studied via X-ray photon correlation spectroscopy" }])
      expect(subject.date).to eq("created" => "2018-01-25", "published" => "2014",
                                 "registered" => "2018-01-25", "updated" => "2020-09-19")
      expect(subject.license).to be_nil
      expect(subject.publisher).to eq("name" => "Deutsches Elektronen-Synchrotron, DESY, Hamburg")
      expect(subject.provider).to eq("DataCite")
    end

    it "funding references" do
      input = "10.26102/2310-6018/2019.24.1.006"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.26102/2310-6018/2019.24.1.006")
      expect(subject.type).to eq("Document")
      expect(subject.contributors.length).to eq(2)
      expect(subject.contributors.first).to eq(
        "affiliation" => [{ "name" => "Тверская государственная сельскохозяйственная академия" }], "familyName" => "Ганичева", "givenName" => "А.В.", "type" => "Person", "contributorRoles" => ["Author"],
      )
      expect(subject.titles.last).to eq("title" => "MODEL OF SYSTEM DYNAMICS OF PROCESS OF TRAINING",
                                        "type" => "TranslatedTitle")
      expect(subject.date).to eq("created" => "2019-02-12", "published" => "2019",
                                 "registered" => "2019-02-12", "updated" => "2022-08-23")
      expect(subject.publisher).to eq("name" => "МОДЕЛИРОВАНИЕ, ОПТИМИЗАЦИЯ И ИНФОРМАЦИОННЫЕ ТЕХНОЛОГИИ")
      expect(subject.license).to be_nil
      expect(subject.funding_references.count).to eq(1)
      expect(subject.funding_references.first).to eq("awardNumber" => "проект № 170100728",
                                                     "funderName" => "РФФИ")
      expect(subject.provider).to eq("DataCite")
    end

    it "subject scheme" do
      input = "https://doi.org/10.4232/1.2745"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.4232/1.2745")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "ZA2745", "alternateIdentifierType" => "ZA-No." },
                                                   { "alternateIdentifier" => "Internationale Umfrageprogramme",
                                                     "alternateIdentifierType" => "FDZ" }])
      expect(subject.type).to eq("Dataset")
      expect(subject.contributors.length).to eq(19)
      expect(subject.contributors.first).to eq(
        "name" => "Europäische Kommission", "contributorRoles" => ["Author"], "type" => "Organization",
      )
      expect(subject.titles).to eq([{ "language" => "de", "title" => "Flash Eurobarometer 54 (Madrid Summit)" },
                                    { "language" => "en", "title" => "Flash Eurobarometer 54 (Madrid Summit)" },
                                    { "language" => "de",
                                      "title" => "The Common European Currency",
                                      "type" => "Subtitle" },
                                    { "language" => "en",
                                      "title" => "The Common European Currency",
                                      "type" => "Subtitle" }])
      expect(subject.subjects).to eq([{ "lang" => "en",
                                        "subject" => "KAT12 International Institutions, Relations, Conditions",
                                        "subjectScheme" => "ZA" },
                                      { "lang" => "de",
                                        "subject" => "Internationale Politik und Internationale Organisationen",
                                        "subjectScheme" => "CESSDA Topic Classification" },
                                      { "lang" => "de",
                                        "subject" => "Wirtschaftssysteme und wirtschaftliche Entwicklung",
                                        "subjectScheme" => "CESSDA Topic Classification" },
                                      { "lang" => "en",
                                        "subject" => "International politics and organisations",
                                        "subjectScheme" => "CESSDA Topic Classification" },
                                      { "lang" => "en",
                                        "subject" => "Economic systems and development",
                                        "subjectScheme" => "CESSDA Topic Classification" }])
      expect(subject.date).to eq("created" => "2012-01-10", "published" => "1996",
                                 "registered" => "2010-07-22", "updated" => "2023-02-02")
      expect(subject.license).to be_nil
      expect(subject.publisher).to eq("name" => "GESIS Data Archive")
      expect(subject.provider).to eq("DataCite")
    end

    it "subject scheme" do
      input = "https://doi.org/10.6084/m9.figshare.3475223.v1"
      subject = described_class.new(input: input)
      expect(subject.id).to eq("https://doi.org/10.6084/m9.figshare.3475223.v1")
      expect(subject.type).to eq("Image")
      expect(subject.contributors).to eq([{ "familyName" => "Franklund", "givenName" => "Clifton",
                                            "type" => "Person", "contributorRoles" => ["Author"] }])
      expect(subject.date).to eq("created" => "2016-07-08",
                                 "published" => "2016",
                                 "registered" => "2016-07-08",
                                 "updated" => "2020-09-04")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
    end

    it "dataset schema v4.5" do
      input = "#{fixture_path}datacite-dataset_v4.5.json"
      subject = described_class.new(input: input)
      expect(subject.id).to eq("https://doi.org/10.82433/b09z-4k37")
      expect(subject.type).to eq("Dataset")
      expect(subject.contributors.length).to eq(23)
      expect(subject.contributors[0]).to eq("contributorRoles" => ["Author"], "familyName" => "ExampleFamilyName", "givenName" => "ExampleGivenName", "type" => "Person")
      expect(subject.contributors[2]).to eq("contributorRoles" => ["ContactPerson"], "familyName" => "ExampleFamilyName", "givenName" => "ExampleGivenName", "type" => "Person")
      expect(subject.date).to eq("created" => "2022-10-27", "published" => "2022", "registered" => "2022-10-27", "updated" => "2024-01-02")
      expect(subject.publisher).to eq("name" => "Example Publisher")
      expect(subject.titles).to eq([{ "language" => "en", "title" => "Example Title" },
                                    { "language" => "en", "title" => "Example Subtitle", "type" => "Subtitle" },
                                    { "language" => "fr",
                                      "title" => "Example TranslatedTitle",
                                      "type" => "TranslatedTitle" },
                                    { "language" => "en",
                                      "title" => "Example AlternativeTitle",
                                      "type" => "AlternativeTitle" }])
      expect(subject.descriptions).to eq([{ "description" => "Example Abstract",
                                            "type" => "Abstract",
                                            "language" => "en" },
                                          { "description" => "Example Methods",
                                            "type" => "Methods",
                                            "language" => "en" },
                                          { "description" => "Example SeriesInformation",
                                            "type" => "Other",
                                            "language" => "en" },
                                          { "description" => "Example TableOfContents",
                                            "type" => "Other",
                                            "language" => "en" },
                                          { "description" => "Example TechnicalInfo",
                                            "type" => "TechnicalInfo",
                                            "language" => "en" },
                                          { "description" => "Example Other", "type" => "Other", "language" => "en" }])
      expect(subject.license).to eq("id" => "CC-PDDC", "url" => "https://creativecommons.org/licenses/publicdomain/")
    end

    it "instrument" do
      input = "#{fixture_path}datacite-instrument.json"
      subject = described_class.new(input: input)
      puts subject.errors unless subject.valid?
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.82433/08qf-ee96")
      expect(subject.type).to eq("Instrument")
      expect(subject.contributors.length).to eq(2)
      expect(subject.contributors.first).to eq("contributorRoles" => ["Author"], "name" => "DECTRIS", "type" => "Organization", "id" => "https://www.wikidata.org/wiki/Q107529885")
      expect(subject.date).to eq("created" => "2022-10-20", "published" => "2022", "registered" => "2022-10-20", "updated" => "2024-01-02")
      expect(subject.publisher).to eq("name" => "Helmholtz Centre Potsdam - GFZ German Research Centre for Geosciences")
      expect(subject.license).to be_nil
    end
  end
end
