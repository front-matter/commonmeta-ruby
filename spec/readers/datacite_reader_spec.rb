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
      expect(subject.creators).to eq([{ "type" => "Person", "givenName" => "Martin", "familyName" => "Fenner",
                                        "id" => "https://orcid.org/0000-0003-1419-2405" }])
      expect(subject.titles).to eq([{ "title" => "Eating your own Dog Food" }])
      expect(subject.alternate_identifiers).to be nil
      expect(subject.date).to eq("created" => "2016-12-20",
                                 "published" => "2016-12-20",
                                 "updated" => "2016-12-20")
      expect(subject.references.length).to eq(2)
      expect(subject.references.first).to eq("doi" => "https://doi.org/10.5438/0012",
                                             "key" => "10.5438/0012")
      expect(subject.provider).to eq("DataCite")
    end

    # it "SoftwareSourceCode" do
    #   input = fixture_path + "datacite_software.json"
    #   subject = Commonmeta::Metadata.new(input: input, from: "datacite")
    #   # # expect(subject.valid?).to be true
    #   expect(subject.identifier).to eq("https://doi.org/10.5063/f1m61h5x")
    #   expect(subject.type).to eq("bibtex"=>"misc", "citeproc"=>"article", "resource_type"=>"Software", "resource_type_general"=>"Software", "ris"=>"COMP", "type"=>"SoftwareSourceCode")
    #   expect(subject.creators).to eq([{"familyName"=>"Jones", "givenName"=>"Matthew B.", "name"=>"Matthew B. Jones", "type"=>"Person"}])
    #   expect(subject.titles).to eq([{"title"=>"dataone: R interface to the DataONE network of data repositories"}])
    #   expect(subject.date).to eq([{"date"=>"2016", "date_type"=>"Issued"}])
    #   expect(subject.publisher).to eq("KNB Data Repository")
    #   expect(subject.provider).to eq("DataCite")
    # end

    it "SoftwareSourceCode missing_comma" do
      input = "#{fixture_path}datacite_software_missing_comma.json"
      subject = described_class.new(input: input, from: "datacite", show_errors: true)
      # expect(subject.valid?).to be false
      expect(subject.errors).to eq(["expected comma, not a string (after doi) at line 4, column 11 [parse.c:435]"])
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
      expect(subject.creators).to eq([{ "type" => "Person",
                                        "givenName" => "Heiko", "familyName" => "Conrad" }])
      expect(subject.titles).to eq([{ "title" => "Dynamics of colloids in molecular glass forming liquids studied via X-ray photon correlation spectroscopy" }])
      expect(subject.date).to eq("created" => "2018-01-25", "published" => "2014", "registered" => "2018-01-25", "updated" => "2020-09-19")
      expect(subject.license).to be nil
      expect(subject.publisher).to eq("name" => "Deutsches Elektronen-Synchrotron, DESY, Hamburg")
      expect(subject.provider).to eq("DataCite")
    end

    it "funding references" do
      input = "10.26102/2310-6018/2019.24.1.006"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.26102/2310-6018/2019.24.1.006")
      expect(subject.type).to eq("Document")
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("affiliation" => [{ "name" => "Тверская государственная сельскохозяйственная академия" }], "familyName" => "Ганичева", "givenName" => "А.В.", "type" => "Person")
      expect(subject.titles.last).to eq("title" => "MODEL OF SYSTEM DYNAMICS OF PROCESS OF TRAINING",
                                        "titleType" => "TranslatedTitle")
      expect(subject.date).to eq("created" => "2019-02-12", "published" => "2019", "registered" => "2019-02-12", "updated" => "2022-08-23")
      expect(subject.publisher).to eq("name" => "МОДЕЛИРОВАНИЕ, ОПТИМИЗАЦИЯ И ИНФОРМАЦИОННЫЕ ТЕХНОЛОГИИ")
      expect(subject.license).to be nil
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
      expect(subject.creators).to eq([{ "name" => "Europäische Kommission", "type" => "Organization" }])
      expect(subject.contributors.length).to eq(18)
      expect(subject.contributors.first).to eq(
        "affiliation" => [{ "name" => "Europäische Kommission, Brüssel" }], "contributorType" => "Researcher", "familyName" => "Reif", "givenName" => "Karlheinz", "type" => "Person",
      )
      expect(subject.titles).to eq([
                                     { "lang" => "de",
                                       "title" => "Flash Eurobarometer 54 (Madrid Summit)" }, { "lang" => "en", "title" => "Flash Eurobarometer 54 (Madrid Summit)" }, { "titleType" => "Subtitle", "lang" => "de", "title" => "The Common European Currency" }, { "titleType" => "Subtitle", "lang" => "en", "title" => "The Common European Currency" },
                                   ])
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
      expect(subject.date).to eq("created" => "2012-01-10", "published" => "1996", "registered" => "2010-07-22", "updated" => "2023-02-02")
      expect(subject.license).to be nil
      expect(subject.publisher).to eq("name" => "GESIS Data Archive")
      expect(subject.provider).to eq("DataCite")
    end

    it "subject scheme" do
      input = "https://doi.org/10.6084/m9.figshare.3475223.v1"
      subject = described_class.new(input: input)
      expect(subject.id).to eq("https://doi.org/10.6084/m9.figshare.3475223.v1")
      expect(subject.type).to eq("Image")
      expect(subject.creators).to eq([{"familyName"=>"Franklund", "givenName"=>"Clifton", "type"=>"Person"}])
      expect(subject.date).to eq("created" => "2016-07-08",
        "published" => "2016",
        "registered" => "2016-07-08",
        "updated" => "2020-09-04")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
        "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
    end
  end
end
