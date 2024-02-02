# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  let(:subject) do
    described_class.new
  end

  context "is_personal_name?" do
    it "has id" do
      author = { "id" => "http://orcid.org/0000-0003-1419-2405", "givenName" => "Martin", "familyName" => "Fenner", "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has orcid id" do
      author = { "creatorName" => "Fenner, Martin", "givenName" => "Martin", "familyName" => "Fenner",
                 "nameIdentifier" => { "schemeURI" => "http://orcid.org/", "nameIdentifierScheme" => "ORCID", "__content__" => "0000-0003-1419-2405" } }
      expect(subject.is_personal_name?(name: author["creatorName"])).to be true
    end

    it "has family name" do
      author = { "givenName" => "Martin", "familyName" => "Fenner", "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has comma" do
      author = { "name" => "Fenner, Martin" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has known given name" do
      author = { "name" => "Martin Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has unknown given name" do
      author = { "name" => "Rintze Zelle" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has middle initial" do
      author = { "name" => "Martin H. Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has unknown given name and middle initial" do
      author = { "name" => "Tejas S. Sathe" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "has no info" do
      author = { "name" => "M Fenner" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "name with title" do
      author = { "name" => "Tejas S. Sathe, MD" }
      expect(subject.is_personal_name?(name: author["name"])).to be true
    end

    it "name with organization string" do
      author = { "name" => "University of California, Santa Barbara" }
      expect(subject.is_personal_name?(name: author["name"])).to be false
    end

    it "name with another organization string" do
      author = { "name" => "Research Graph" }
      expect(subject.is_personal_name?(name: author["name"])).to be false
    end

    it "name with ye another organization string" do
      author = { "name" => "Team OA Brandenburg" }
      expect(subject.is_personal_name?(name: author["name"])).to be false
    end
  end

  context "cleanup_author" do
    it "Smith J." do
      author = "Smith J."
      expect(subject.cleanup_author(author)).to eq("Smith, J.")
    end

    it "Smith, John" do
      author = "Smith, John"
      expect(subject.cleanup_author(author)).to eq("Smith, John")
    end

    it "John Smith" do
      author = "John Smith"
      expect(subject.cleanup_author(author)).to eq("John Smith")
    end

    it "with email" do
      author = "noreply@blogger.com (Roderic Page)"
      expect(subject.cleanup_author(author)).to eq("Roderic Page")
    end
  end

  context "get_one_author" do
    it "has type organization" do
      author = { "email" => "info@ucop.edu", "name" => "University of California, Santa Barbara",
                 "role" => { "namespace" => "http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode" => "copyrightHolder" }, "type" => "Organization" }
      response = subject.get_one_author(author)
      expect(response).to eq("name" => "University of California, Santa Barbara", "type" => "Organization", "contributorRoles" => ["Author"])
    end

    it "has familyName" do
      input = "https://doi.org/10.5438/4K3M-NYVG"
      subject = described_class.new(input: input)
      meta = JSON.parse(subject.raw).dig("data", "attributes")
      response = subject.get_one_author(meta.dig("creators").first)
      expect(response).to eq(
        "id" => "https://orcid.org/0000-0003-1419-2405",
        "givenName" => "Martin", "familyName" => "Fenner", "type" => "Person", "contributorRoles" => ["Author"],
      )
    end

    it "has name with title" do
      author = { "name" => "Tejas S. Sathe, MD" }
      response = subject.get_one_author(author)
      expect(response).to eq("givenName" => "Tejas S.", "familyName" => "Sathe", "type" => "Person", "contributorRoles" => ["Author"])
    end

    it "has name in display-order with ORCID" do
      input = "https://doi.org/10.6084/M9.FIGSHARE.4700788"
      subject = described_class.new(input: input)
      meta = JSON.parse(subject.raw).dig("data", "attributes")
      response = subject.get_one_author(meta.dig("creators").first)
      expect(response).to eq("type" => "Person", "contributorRoles" => ["Author"],
                             "id" => "https://orcid.org/0000-0003-4881-1606",
                             "givenName" => "Andrea", "familyName" => "Bedini")
    end

    it "is organization" do
      author = { "email" => "info@ucop.edu",
                 "name" => { "__content__" => "University of California, Santa Barbara" },
                 "type" => "Organization", "role" => { "namespace" => "http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode" => "copyrightHolder" } }
      response = subject.get_one_author(author)
      expect(response).to eq("name" => "University of California, Santa Barbara",
                             "type" => "Organization", "contributorRoles" => ["Author"])
    end

    it "is another organization" do
      author = { "name" => "University of California, Santa Barbara",
                 "id" => "https://ror.org/02t274463" }
      response = subject.get_one_author(author)
      expect(response).to eq("id" => "https://ror.org/02t274463", "name" => "University of California, Santa Barbara", "type" => "Organization", "contributorRoles" => ["Author"])
    end

    it "is anonymous" do
      author = { "id" => "https://ror.org/05745n787" }
      response = subject.get_one_author(author)
      expect(response).to eq("type" => "Person", "contributorRoles" => ["Author"], "affiliation" => [{ "id" => "https://ror.org/05745n787" }])
    end

    it "name with affiliation crossref" do
      input = "10.7554/elife.01567"
      subject = described_class.new(input: input, from: "crossref")
      response = subject.get_one_author(subject.contributors.first)
      expect(response).to eq("affiliation" => [{ "name" => "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland" }], "familyName" => "Sankar",
                             "givenName" => "Martial",
                             "type" => "Person", "contributorRoles" => ["Author"])
    end

    it "only familyName and givenName" do
      input = "https://doi.pangaea.de/10.1594/PANGAEA.836178"
      subject = described_class.new(input: input, from: "schema_org")
      response = subject.get_one_author(subject.contributors.first)
      expect(response).to eq("type" => "Person", "contributorRoles" => ["Author"], "givenName" => "Emma", "familyName" => "Johansson")
    end

    it "affiliation is space" do
      input = "10.1177/0042098011428175"
      subject = described_class.new(input: input)
      response = subject.get_one_author(subject.contributors.first)
      expect(response).to eq("familyName" => "Petrovici", "givenName" => "Norbert", "type" => "Person", "contributorRoles" => ["Author"])
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

  context "get_affiliations" do
    it "name" do
      affiliation = [{ "name" => "University of Zurich, Zurich, Switzerland" }]
      response = subject.get_affiliations(affiliation)
      expect(response).to eq([{ "name" => "University of Zurich, Zurich, Switzerland" }])
    end

    it "name and ROR ID" do
      affiliation = { "id" => "https://ror.org/02t274463",
                      "name" => "University of California, Santa Barbara" }
      response = subject.get_affiliations(affiliation)
      expect(response).to eq([{ "name" => "University of California, Santa Barbara" }])
    end

    it "only ROR ID" do
      affiliation = { "affiliationIdentifier" => "https://ror.org/02t274463" }
      response = subject.get_affiliations(affiliation)
      expect(response).to eq([{ "id" => "https://ror.org/02t274463" }])
    end
  end
end
