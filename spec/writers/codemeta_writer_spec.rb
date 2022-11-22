# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context 'write metadata as codemeta' do
    # it "SoftwareSourceCode DataCite JSON" do
    #   input = fixture_path + "datacite_software.json"
    #   subject = Briard::Metadata.new(input: input, from: "datacite_json")
    #   expect(subject.valid?).to be true
    #   json = JSON.parse(subject.codemeta)
    #   expect(json["@context"]).to eq("https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld")
    #   expect(json["@id"]).to eq("https://doi.org/10.5063/f1m61h5x")
    #   expect(json["@type"]).to eq("SoftwareSourceCode")
    #   expect(json["identifier"]).to eq("https://doi.org/10.5063/f1m61h5x")
    #   expect(json["agents"]).to eq("type"=>"Person", "name"=>"Matthew B. Jones", "givenName"=>"Matthew B.", "familyName"=>"Jones")
    #   expect(json["title"]).to eq("dataone: R interface to the DataONE network of data repositories")
    #   expect(json["datePublished"]).to eq("2016")
    #   expect(json["publisher"]).to eq("KNB Data Repository")
    # end

    it 'SoftwareSourceCode DataCite' do
      input = 'https://doi.org/10.5063/f1m61h5x'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.codemeta)
      expect(json['@context']).to eq('https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld')
      expect(json['@id']).to eq('https://doi.org/10.5063/f1m61h5x')
      expect(json['@type']).to eq('SoftwareSourceCode')
      expect(json['authors']).to eq([{
                                      'name' => 'Jones, Matthew B.; Slaughter, Peter; Nahf, Rob; Boettiger, Carl ; Jones, Chris; Read, Jordan; Walker, Lauren; Hart, Edmund; Chamberlain, Scott'
                                    }])
      expect(json['name']).to eq('dataone: R interface to the DataONE network of data repositories')
      expect(json['datePublished']).to eq('2016')
      expect(json['publisher']).to eq('KNB Data Repository')
    end

    it 'SoftwareSourceCode DataCite check codemeta v2' do
      input = 'https://doi.org/10.5063/f1m61h5x'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.codemeta)
      expect(json['agents'].nil?).to be(true)
      expect(json['title'].nil?).to be(true)
    end
  end
end
