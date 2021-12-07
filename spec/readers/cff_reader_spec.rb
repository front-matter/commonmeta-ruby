# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  let(:input) { "https://github.com/citation-file-format/ruby-cff/blob/main/CITATION.cff" }

  subject { Briard::Metadata.new(input: input) }

  context "get cff metadata" do
    it "ruby-cff" do
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5281/zenodo.1184077")
      expect(subject.url).to eq("https://github.com/citation-file-format/ruby-cff")
      expect(subject.types).to eq("bibtex"=>"misc", "citeproc"=>"article-journal", "resourceTypeGeneral"=>"Software", "ris"=>"COMP", "schemaOrg"=>"SoftwareSourceCode")
      expect(subject.creators).to eq([{"affiliation"=>[{"name"=>"The University of Manchester, UK"}], "familyName"=>"Haines", "givenName"=>"Robert", "name"=>"Haines, Robert", "nameIdentifiers"=>
        [{"nameIdentifier"=>"https://orcid.org/0000-0002-9538-7919",
          "nameIdentifierScheme"=>"ORCID",
          "schemeUri"=>"https://orcid.org"}], "nameType"=>"Personal"}, {"name"=>"The Ruby Citation File Format Developers", "nameType"=>"Organizational"}])
      expect(subject.titles).to eq([{"title"=>"Ruby CFF Library"}])
      expect(subject.descriptions.first["description"]).to start_with("This library provides a Ruby interface to manipulate Citation File Format files")
      expect(subject.subjects).to eq([{"subject"=>"ruby"},
        {"subject"=>"credit"},
        {"subject"=>"software citation"},
        {"subject"=>"research software"},
        {"subject"=>"software sustainability"},
        {"subject"=>"metadata"},
        {"subject"=>"citation file format"},
        {"subject"=>"CFF"}])
      expect(subject.version_info).to eq("0.9.0")
      expect(subject.dates).to eq([{"date"=>"2021-08-18", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2021")
      expect(subject.publisher).to eq("GitHub")
      expect(subject.rights_list).to eq([{"rights"=>"Apache License 2.0",
        "rightsIdentifier"=>"apache-2.0",
        "rightsIdentifierScheme"=>"SPDX",
        "rightsUri"=>"http://www.apache.org/licenses/LICENSE-2.0",
        "schemeUri"=>"https://spdx.org/licenses/"}])
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"https://doi.org/10.5281/zenodo.1003149", "relatedIdentifierType"=>"DOI", "relationType"=>"References"}])
    end

    it "cff-converter-python" do
      input = "https://github.com/citation-file-format/cff-converter-python/blob/main/CITATION.cff"
      subject = Briard::Metadata.new(input: input)
      expect(subject.id).to eq("https://doi.org/10.5281/zenodo.1162057")
      expect(subject.url).to eq("https://github.com/citation-file-format/cff-converter-python")
      expect(subject.types).to eq("bibtex"=>"misc", "citeproc"=>"article-journal", "resourceTypeGeneral"=>"Software", "ris"=>"COMP", "schemaOrg"=>"SoftwareSourceCode")
      expect(subject.creators).to eq([{"affiliation"=>[{"name"=>"Netherlands eScience Center"}],
        "familyName"=>"Spaaks",
        "givenName"=>"Jurriaan H.",
        "name"=>"Spaaks, Jurriaan H.",
        "nameIdentifiers"=>
          [{"nameIdentifier"=>"https://orcid.org/0000-0002-7064-4069",
            "nameIdentifierScheme"=>"ORCID",
            "schemeUri"=>"https://orcid.org"}],
        "nameType"=>"Personal"},
       {"affiliation"=>[{"name"=>"Netherlands eScience Center"}],
        "familyName"=>"Klaver",
        "givenName"=>"Tom",
        "name"=>"Klaver, Tom",
        "nameType"=>"Personal"},
      {"affiliation"=>[{"name"=>"Netherlands eScience Center"}],
        "familyName"=>"Verhoeven",
        "givenName"=>"Stefan",
        "name"=>"Verhoeven, Stefan",
        "nameIdentifiers"=>
          [{"nameIdentifier"=>"https://orcid.org/0000-0002-5821-2060",
            "nameIdentifierScheme"=>"ORCID",
            "schemeUri"=>"https://orcid.org"}],
        "nameType"=>"Personal"},
       {"affiliation"=>[{"name"=>"Humboldt-Universit??t zu Berlin"}],
        "familyName"=>"Druskat",
        "givenName"=>"Stephan",
        "name"=>"Druskat, Stephan",
        "nameIdentifiers"=>
          [{"nameIdentifier"=>"https://orcid.org/0000-0003-4925-7248",
            "nameIdentifierScheme"=>"ORCID",
            "schemeUri"=>"https://orcid.org"}],
        "nameType"=>"Personal"},
       {"affiliation"=>[{"name"=>"University of Oslo"}],
        "familyName"=>"Leoncio",
        "givenName"=>"Waldir",
        "name"=>"Leoncio, Waldir",
        "nameType"=>"Personal"}])
      expect(subject.titles).to eq([{"title"=>"cffconvert"}])
      expect(subject.descriptions.first["description"]).to start_with("Command line program to validate and convert CITATION.cff files")
      expect(subject.subjects).to eq([{"subject"=>"bibliography"},
        {"subject"=>"BibTeX"},
        {"subject"=>"cff"},
        {"subject"=>"citation"},
        {"subject"=>"CITATION.cff"},
        {"subject"=>"CodeMeta"},
        {"subject"=>"EndNote"},
        {"subject"=>"RIS"},
        {"subject"=>"Citation File Format"}])
      expect(subject.version_info).to eq("2.0.0")
      expect(subject.dates).to eq([{"date"=>"2021-09-22", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2021")
      expect(subject.publisher).to eq("GitHub")
      expect(subject.rights_list).to eq([{"rights"=>"Apache License 2.0",
        "rightsIdentifier"=>"apache-2.0",
        "rightsIdentifierScheme"=>"SPDX",
        "rightsUri"=>"http://www.apache.org/licenses/LICENSE-2.0",
        "schemeUri"=>"https://spdx.org/licenses/"}])
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"https://doi.org/10.5281/zenodo.1310751", "relatedIdentifierType"=>"DOI", "relationType"=>"References"}])
    end

    it "ruby-cff" do
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5281/zenodo.1184077")
      expect(subject.url).to eq("https://github.com/citation-file-format/ruby-cff")
      expect(subject.types).to eq("bibtex"=>"misc", "citeproc"=>"article-journal", "resourceTypeGeneral"=>"Software", "ris"=>"COMP", "schemaOrg"=>"SoftwareSourceCode")
      expect(subject.creators).to eq([{"affiliation"=>[{"name"=>"The University of Manchester, UK"}], "familyName"=>"Haines", "givenName"=>"Robert", "name"=>"Haines, Robert", "nameIdentifiers"=>
        [{"nameIdentifier"=>"https://orcid.org/0000-0002-9538-7919",
          "nameIdentifierScheme"=>"ORCID",
          "schemeUri"=>"https://orcid.org"}], "nameType"=>"Personal"}, {"name"=>"The Ruby Citation File Format Developers", "nameType"=>"Organizational"}])
      expect(subject.titles).to eq([{"title"=>"Ruby CFF Library"}])
      expect(subject.descriptions.first["description"]).to start_with("This library provides a Ruby interface to manipulate Citation File Format files")
      expect(subject.subjects).to eq([{"subject"=>"ruby"},
        {"subject"=>"credit"},
        {"subject"=>"software citation"},
        {"subject"=>"research software"},
        {"subject"=>"software sustainability"},
        {"subject"=>"metadata"},
        {"subject"=>"citation file format"},
        {"subject"=>"CFF"}])
      expect(subject.version_info).to eq("0.9.0")
      expect(subject.dates).to eq([{"date"=>"2021-08-18", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2021")
      expect(subject.publisher).to eq("GitHub")
      expect(subject.rights_list).to eq([{"rights"=>"Apache License 2.0",
        "rightsIdentifier"=>"apache-2.0",
        "rightsIdentifierScheme"=>"SPDX",
        "rightsUri"=>"http://www.apache.org/licenses/LICENSE-2.0",
        "schemeUri"=>"https://spdx.org/licenses/"}])
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"https://doi.org/10.5281/zenodo.1003149", "relatedIdentifierType"=>"DOI", "relationType"=>"References"}])
    end

    it "ruby-cff repository url" do
      input = "https://github.com/citation-file-format/ruby-cff"
      subject = Briard::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.5281/zenodo.1184077")
      expect(subject.url).to eq("https://github.com/citation-file-format/ruby-cff")
      expect(subject.types).to eq("bibtex"=>"misc", "citeproc"=>"article-journal", "resourceTypeGeneral"=>"Software", "ris"=>"COMP", "schemaOrg"=>"SoftwareSourceCode")
      expect(subject.creators).to eq([{"affiliation"=>[{"name"=>"The University of Manchester, UK"}], "familyName"=>"Haines", "givenName"=>"Robert", "name"=>"Haines, Robert", "nameIdentifiers"=>
        [{"nameIdentifier"=>"https://orcid.org/0000-0002-9538-7919",
          "nameIdentifierScheme"=>"ORCID",
          "schemeUri"=>"https://orcid.org"}], "nameType"=>"Personal"}, {"name"=>"The Ruby Citation File Format Developers", "nameType"=>"Organizational"}])
      expect(subject.titles).to eq([{"title"=>"Ruby CFF Library"}])
      expect(subject.descriptions.first["description"]).to start_with("This library provides a Ruby interface to manipulate Citation File Format files")
      expect(subject.subjects).to eq([{"subject"=>"ruby"},
        {"subject"=>"credit"},
        {"subject"=>"software citation"},
        {"subject"=>"research software"},
        {"subject"=>"software sustainability"},
        {"subject"=>"metadata"},
        {"subject"=>"citation file format"},
        {"subject"=>"CFF"}])
      expect(subject.version_info).to eq("0.9.0")
      expect(subject.dates).to eq([{"date"=>"2021-08-18", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2021")
      expect(subject.publisher).to eq("GitHub")
      expect(subject.rights_list).to eq([{"rights"=>"Apache License 2.0",
        "rightsIdentifier"=>"apache-2.0",
        "rightsIdentifierScheme"=>"SPDX",
        "rightsUri"=>"http://www.apache.org/licenses/LICENSE-2.0",
        "schemeUri"=>"https://spdx.org/licenses/"}])
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"https://doi.org/10.5281/zenodo.1003149", "relatedIdentifierType"=>"DOI", "relationType"=>"References"}])
    end
  end
end
