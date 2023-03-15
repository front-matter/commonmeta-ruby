# frozen_string_literal: true

require "spec_helper"

describe Briard::Metadata, vcr: true do
  let(:subject) do
    described_class.new
  end

  context "is_personal_name?" do
    it "has type organization" do
      author = { "email" => "info@ucop.edu", "name" => "University of California, Santa Barbara",
                 "role" => { "namespace" => "http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode" => "copyrightHolder" }, "nameType" => "Organizational" }
      expect(subject.is_personal_name?(name: author["name"])).to be false
    end

    it "has id" do
      author = { "id" => "http://orcid.org/0000-0003-1419-2405", "givenName" => "Martin", "familyName" => "Fenner", "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(given_name: author["given_name"], name: author["name"])).to be true
    end

    it "has orcid id" do
      author = { "creatorName" => "Fenner, Martin", "givenName" => "Martin", "familyName" => "Fenner",
                 "nameIdentifier" => { "schemeURI" => "http://orcid.org/", "nameIdentifierScheme" => "ORCID", "__content__" => "0000-0003-1419-2405" } }
      expect(subject.is_personal_name?(given_name: author["givenName"], name: author["creatorName"])).to be true
    end

    it "has family name" do
      author = { "givenName" => "Martin", "familyName" => "Fenner", "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(given_name: author["givenName"], name: author["name"])).to be true
    end

    it "has comma" do
      author = { "name" => "Fenner, Martin" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has known given name" do
      author = { "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has no info" do
      author = { "name" => "M Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be false
    end
  end

  context "get_one_author" do
    it "has familyName" do
      input = "https://doi.org/10.5438/4K3M-NYVG"
      subject = described_class.new(input: input)
      meta = JSON.parse(subject.raw).dig("data", "attributes")
      response = subject.get_one_author(meta.dig("creators").first)
      expect(response).to eq(
        "nameIdentifiers" => [{ "nameIdentifier" => "https://orcid.org/0000-0003-1419-2405",
                                "nameIdentifierScheme" => "ORCID", "schemeUri" => "https://orcid.org" }],
        "name" => "Fenner, Martin", "givenName" => "Martin", "familyName" => "Fenner",
        "nameType" => "Personal",
      )
    end

    it "has name in display-order with ORCID" do
      input = "https://doi.org/10.6084/M9.FIGSHARE.4700788"
      subject = described_class.new(input: input)
      meta = JSON.parse(subject.raw).dig("data", "attributes")
      response = subject.get_one_author(meta.dig("creators").first)
      expect(response).to eq("nameType" => "Personal",
                             "nameIdentifiers" => [{ "nameIdentifier" => "https://orcid.org/0000-0003-4881-1606", "nameIdentifierScheme" => "ORCID", "schemeUri" => "https://orcid.org" }], "name" => "Bedini, Andrea", "givenName" => "Andrea", "familyName" => "Bedini")
    end

    it "is organization" do
      author = { "email" => "info@ucop.edu",
                 "creatorName" => { "__content__" => "University of California, Santa Barbara", "nameType" => "Organizational" }, "role" => { "namespace" => "http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode" => "copyrightHolder" } }
      response = subject.get_one_author(author)
      expect(response).to eq("name" => "University of California, Santa Barbara", "nameType" => "Organizational")
    end

    it "name with affiliation crossref" do
      input = "10.7554/elife.01567"
      subject = described_class.new(input: input, from: "crossref")
      response = subject.get_one_author(subject.creators.first)
      expect(response).to eq("affiliation" => [{ "name" => "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland" }], "familyName" => "Sankar",
                             "givenName" => "Martial",
                             "name" => "Sankar, Martial", "nameType" => "Personal")
    end

    it "only familyName and givenName" do
      input = "https://doi.pangaea.de/10.1594/PANGAEA.836178"
      subject = described_class.new(input: input, from: "schema_org")
      expect(subject.creators.first).to eq("nameType" => "Personal", "name" => "Johansson, Emma",
                                           "givenName" => "Emma", "familyName" => "Johansson")
    end
  end

  context "authors_as_string" do
    let(:authors) do
      [{ "type" => "Person",
         "id" => "https://orcid.org/0000-0003-0077-4738",
         "givenName" => "Matt",
         "familyName" => "Jones" },
       { "type" => "Person",
         "id" => "https://orcid.org/0000-0002-2192-403X",
         "givenName" => "Peter",
         "familyName" => "Slaughter" },
       { "type" => "Organization",
         "id" => "https://ror.org/02t274463",
         "name" => "University of California, Santa Barbara" }]
    end

    it "authors" do
      response = subject.authors_as_string(authors[0..1])
      expect(response).to eq("Jones, Matt and Slaughter, Peter")
    end

    it "single author" do
      response = subject.authors_as_string(authors.first)
      expect(response).to eq("Jones, Matt")
    end

    it "no author" do
      response = subject.authors_as_string(nil)
      expect(response.nil?).to be(true)
    end

    it "with organization" do
      response = subject.authors_as_string(authors)
      expect(response).to eq("Jones, Matt and Slaughter, Peter and {University of California, Santa Barbara}")
    end
  end
end
