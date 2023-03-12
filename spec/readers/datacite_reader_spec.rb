# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { "#{fixture_path}datacite.json" }

  context 'get datacite raw' do
    it 'BlogPosting' do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context 'get datacite metadata' do
    it 'BlogPosting' do
      expect(subject.valid?).to be true
      expect(subject.types).to eq('bibtex' => 'article', 'citeproc' => 'article-journal',
                                  'resourceType' => 'BlogPosting', 'resourceTypeGeneral' => 'Text', 'ris' => 'RPRT', 'schemaOrg' => 'ScholarlyArticle')
      expect(subject.creators).to eq([{ 'type' => 'Person',
                                        'id' => 'http://orcid.org/0000-0003-1419-2405', 'name' => 'Fenner, Martin', 'givenName' => 'Martin', 'familyName' => 'Fenner' }])
      expect(subject.titles).to eq([{ 'title' => 'Eating your own Dog Food' }])
      expect(subject.identifiers).to eq([
                                          { 'identifier' => 'https://doi.org/10.5438/4k3m-nyvg',
                                            'identifierType' => 'DOI' }, { 'identifier' => 'MS-49-3632-5083', 'identifierType' => 'Local accession number' }
                                        ])
      expect(subject.dates).to eq([{ 'date' => '2016-12-20', 'dateType' => 'Created' },
                                   { 'date' => '2016-12-20', 'dateType' => 'Issued' }, { 'date' => '2016-12-20', 'dateType' => 'Updated' }])
      expect(subject.publication_year).to eq(2016)
      expect(subject.related_identifiers.length).to eq(3)
      expect(subject.related_identifiers.first).to eq('relatedIdentifier' => '10.5438/0000-00ss',
                                                      'relatedIdentifierType' => 'DOI', 'relationType' => 'IsPartOf')
      expect(subject.related_identifiers.last).to eq('relatedIdentifier' => '10.5438/55e5-t5c0',
                                                     'relatedIdentifierType' => 'DOI', 'relationType' => 'References')
      expect(subject.agency).to eq('DataCite')
    end

    # it "SoftwareSourceCode" do
    #   input = fixture_path + "datacite_software.json"
    #   subject = Briard::Metadata.new(input: input, from: "datacite")
    #   # expect(subject.valid?).to be true
    #   expect(subject.identifier).to eq("https://doi.org/10.5063/f1m61h5x")
    #   expect(subject.types).to eq("bibtex"=>"misc", "citeproc"=>"article", "resource_type"=>"Software", "resource_type_general"=>"Software", "ris"=>"COMP", "type"=>"SoftwareSourceCode")
    #   expect(subject.creators).to eq([{"familyName"=>"Jones", "givenName"=>"Matthew B.", "name"=>"Matthew B. Jones", "type"=>"Person"}])
    #   expect(subject.titles).to eq([{"title"=>"dataone: R interface to the DataONE network of data repositories"}])
    #   expect(subject.dates).to eq([{"date"=>"2016", "date_type"=>"Issued"}])
    #   expect(subject.publication_year).to eq("2016")
    #   expect(subject.publisher).to eq("KNB Data Repository")
    #   expect(subject.agency).to eq("DataCite")
    # end

    it 'SoftwareSourceCode missing_comma' do
      input = "#{fixture_path}datacite_software_missing_comma.json"
      subject = described_class.new(input: input, from: 'datacite', show_errors: true)
      # expect(subject.valid?).to be false
      expect(subject.errors).to eq(['expected comma, not a string (after doi) at line 4, column 11 [parse.c:435]'])
      expect(subject.codemeta.nil?).to be(true)
    end

    it 'SoftwareSourceCode overlapping_keys' do
      input = "#{fixture_path}datacite_software_overlapping_keys.json"
      subject = described_class.new(input: input, from: 'datacite', show_errors: true)
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["root is missing required keys: id, titles, types", "property '/creators' is invalid: error_type=minItems"])
      expect(subject.codemeta.nil?).to be(true)
    end

    it "dissertation" do
      input = "10.3204/desy-2014-01645"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.3204/desy-2014-01645")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["resourceType"]).to eq("Dissertation")
      expect(subject.types["schemaOrg"]).to eq("Thesis")
      expect(subject.types["bibtex"]).to eq("phdthesis")
      expect(subject.types["citeproc"]).to eq("thesis")
      expect(subject.creators).to eq([{ "nameType" => "Personal", "name" => "Conrad, Heiko",
                                        "givenName" => "Heiko", "familyName" => "Conrad" }])
      expect(subject.titles).to eq([{ "title" => "Dynamics of colloids in molecular glass forming liquids studied via X-ray photon correlation spectroscopy" }])
      expect(subject.dates).to eq([{ "date" => "2014", "dateType" => "Issued" },
                                   { "date" => "2014", "dateType" => "Copyrighted" },
                                   { "date" => "2009-10-01/2014-01-23", "dateType" => "Created" }])
      expect(subject.publication_year).to eq(2014)
      expect(subject.publisher).to eq("Deutsches Elektronen-Synchrotron, DESY, Hamburg")
      expect(subject.agency).to eq("DataCite")
      # expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "funding references" do
      input = "10.26102/2310-6018/2019.24.1.006"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.26102/2310-6018/2019.24.1.006")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["resourceType"]).to eq("Journal Article")
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["bibtex"]).to eq("article")
      expect(subject.types["citeproc"]).to eq("article-journal")
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("affiliation" => [{ "name" => "Тверская государственная сельскохозяйственная академия" }],
                                           "name" => "Ганичева, А.В.")
      expect(subject.titles.last).to eq("title" => "MODEL OF SYSTEM DYNAMICS OF PROCESS OF TRAINING",
                                        "titleType" => "TranslatedTitle")
      expect(subject.dates).to eq([{ "date" => "2019-02-09", "dateType" => "Issued" }])
      expect(subject.publication_year).to eq(2019)
      expect(subject.publisher).to eq("МОДЕЛИРОВАНИЕ, ОПТИМИЗАЦИЯ И ИНФОРМАЦИОННЫЕ ТЕХНОЛОГИИ")
      expect(subject.funding_references.count).to eq(1)
      expect(subject.funding_references.first).to eq("awardNumber" => "проект № 170100728",
                                                     "funderName" => "РФФИ")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "subject scheme" do
      input = "https://doi.org/10.4232/1.2745"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.4232/1.2745")
      expect(subject.identifiers).to eq([{ "identifier" => "ZA2745", "identifierType" => "ZA-No." },
                                         { "identifier" => "Internationale Umfrageprogramme",
                                           "identifierType" => "FDZ" }])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{ "name" => "Europäische Kommission", "nameType" => "Organizational" }])
      expect(subject.contributors.length).to eq(18)
      expect(subject.contributors.first).to eq(
        "affiliation" => [{ "name" => "Europäische Kommission, Brüssel" }], "contributorType" => "Researcher", "familyName" => "Reif", "givenName" => "Karlheinz", "name" => "Reif, Karlheinz", "nameType" => "Personal",
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
      expect(subject.dates).to eq([{ "date" => "1995-12", "dateType" => "Collected" },
                                   { "date" => "1996", "dateType" => "Issued" }])
      expect(subject.publication_year).to eq("1996")
      expect(subject.publisher).to eq("GESIS Data Archive")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end
  end
end
