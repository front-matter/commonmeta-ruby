# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  context "write metadata as crossref" do
    it "journal article" do
      input = "#{fixture_path}crossref.xml"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.url).to eq("https://elifesciences.org/articles/01567")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("crossref_result", "query_result",
                                                             "body", "query", "doi_record", "crossref", "journal")
      expect(crossref_xml.dig("journal_metadata", "full_title")).to eq("eLife")
      expect(crossref_xml.dig("journal_article", "doi_data", "doi")).to eq("10.7554/eLife.01567")
      expect(crossref_xml.dig("journal_article", "citation_list", "citation").length).to eq(27)
      expect(crossref_xml.dig("journal_article", "citation_list",
                              "citation").first).to eq("article_title" => "APL regulates vascular tissue identity in Arabidopsis",
                                                       "author" => "Bonke",
                                                       "cYear" => "2003",
                                                       "doi" => "10.1038/nature02100",
                                                       "first_page" => "181",
                                                       "journal_title" => "Nature",
                                                       "key" => "bib1",
                                                       "volume" => "426")
    end

    it "posted_content" do
      subject = described_class.new(input: "10.1101/2020.12.01.406702", depositor: "test", email: "info@example.org", registrant: "test")
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.1101/2020.12.01.406702")
      expect(subject.url).to eq("http://biorxiv.org/lookup/doi/10.1101/2020.12.01.406702")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(crossref_xml.dig("doi_data", "doi")).to eq("10.1101/2020.12.01.406702")
      expect(crossref_xml.dig("doi_data", "resource")).to eq("http://biorxiv.org/lookup/doi/10.1101/2020.12.01.406702")
    end

    it "journal article from datacite" do
      input = "10.2312/geowissenschaften.1989.7.181"
      subject = described_class.new(input: input, from: "datacite")
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["property '/descriptions/0' is missing required keys: description"])
      expect(subject.id).to eq("https://doi.org/10.2312/geowissenschaften.1989.7.181")
      expect(subject.url).to eq("https://www.tib.eu/suchen/id/awi:7058a56c5e43afd705af945d01536b9aaeeee491")
      expect(subject.type).to eq("JournalArticle")
      expect(subject.titles).to eq([{ "title" => "An Overview of the Geology of Canadian Gold Occurrences" }])
      expect(subject.publisher).to eq("name" => "VCH Verlagsgesellschaft mbH")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "journal",
                                                             "journal_article")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("contributor_role" => "author", "given_name" => "David J",
                                                                      "sequence" => "first", "surname" => "Mossman")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("An Overview of the Geology of Canadian Gold Occurrences")
    end

    it "schema.org from front matter" do
      input = "https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health"
      subject = described_class.new(input: input, from: "schema_org")
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/r9nqx6h-97aq74v-ag7bw")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health" }])
      expect(subject.creators).to eq([{ "familyName" => "Fenner",
                                        "givenName" => "Martin",
                                        "id" => "https://orcid.org/0000-0003-1419-2405",
                                        "type" => "Person" }])
      expect(subject.subjects).to eq([{ "subject" => "News" }])
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health")
    end

    it "another schema.org from front-matter" do
      input = "https://blog.front-matter.io/posts/dryad-interview-jen-gibson"
      subject = described_class.new(input: input, from: "schema_org")
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/rceh7pn-tzg61kj-7zv63")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/dryad-interview-jen-gibson")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "Dryad: Interview with Jen Gibson" }])
      expect(subject.creators).to eq([{ "familyName" => "Fenner",
                                        "givenName" => "Martin",
                                        "id" => "https://orcid.org/0000-0003-1419-2405",
                                        "type" => "Person" }])
      expect(subject.subjects).to eq([{ "subject" => "Interview" }])
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io/", "identifierType" => "URL",
                                      "title" => "Front Matter", "type" => "Periodical")
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(crossref_xml.dig("titles", "title")).to eq("Dryad: Interview with Jen Gibson")
    end

    it "embedded schema.org from front matter" do
      input = "#{fixture_path}schema_org_front-matter.json"
      subject = described_class.new(input: input, from: "schema_org")
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/r9nqx6h-97aq74v-ag7bw")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health")
      expect(subject.type).to eq("Article")
      expect(subject.container).to eq("identifier" => "2749-9952", "identifierType" => "ISSN",
                                      "title" => "Front Matter", "type" => "Periodical")
      expect(subject.titles).to eq([{ "title" => "Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health" }])
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("ORCID" => "https://orcid.org/0000-0003-1419-2405",
                                                                      "contributor_role" => "author", "given_name" => "Martin", "sequence" => "first", "surname" => "Fenner")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health")
    end

    it "schema.org from another science blog" do
      input = "https://donnywinston.com/posts/implementing-the-fair-principles-through-fair-enabling-artifacts-and-services/"
      subject = described_class.new(input: input, from: "schema_org")
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.57099/11h5yt3819")
      expect(subject.url).to eq("https://donnywinston.com/posts/implementing-the-fair-principles-through-fair-enabling-artifacts-and-services")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "Implementing the FAIR Principles Through FAIR-Enabling Artifacts and Services" }])
      expect(subject.creators).to eq([{ "familyName" => "Winston",
                                        "givenName" => "Donny",
                                        "id" => "https://orcid.org/0000-0002-8424-0604",
                                        "type" => "Person" }])
      expect(subject.subjects).to eq([])
      expect(subject.container).to eq("identifier" => "https://www.polyneme.xyz",
                                      "identifierType" => "URL", "type" => "Periodical")
      expect(subject.language).to eq("en-US")
      expect(subject.date).to eq("created" => "2022-10-21",
                                 "published" => "2022-10-21",
                                 "updated" => "2022-10-21")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Implementing the FAIR Principles Through FAIR-Enabling Artifacts and Services")
    end

    it "schema.org from upstream blog" do
      input = "https://upstream.force11.org/deep-dive-into-ethics-of-contributor-roles/"
      subject = described_class.new(input: input, from: "schema_org")

      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.54900/rf84ag3-98f00rt-0phta")
      expect(subject.url).to eq("https://upstream.force11.org/deep-dive-into-ethics-of-contributor-roles")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "Deep dive into ethics of Contributor Roles: report of a FORCE11 workshop" }])
      expect(subject.creators.length).to eq(4)
      expect(subject.creators.first).to eq("familyName" => "Hosseini",
                                           "givenName" => "Mohammad",
                                           "type" => "Person")
      expect(subject.subjects).to eq([{ "subject" => "News" }])
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(4)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("contributor_role" => "author", "given_name" => "Mohammad",
                                                                      "sequence" => "first", "surname" => "Hosseini")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Deep dive into ethics of Contributor Roles: report of a FORCE11 workshop")
    end

    it "json_feed_item from upstream blog" do
      input = "https://rogue-scholar.org/api/posts/5d14ffac-b9ac-4e20-bdc0-d9248df4e80d"
      subject = described_class.new(input: input)

      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.54900/n6dnt-xpq48")
      expect(subject.url).to eq("https://upstream.force11.org/attempts-at-automating-journal-subject-classification")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "Attempts at automating journal subject classification" }])
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName" => "Datta", "givenName" => "Esha", "id" => "https://orcid.org/0000-0001-9165-2757", "type" => "Person")
      expect(subject.subjects).to eq([{ "subject" => "Humanities" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Humanities",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("ORCID" => "https://orcid.org/0000-0001-9165-2757", "contributor_role" => "author", "given_name" => "Esha", "sequence" => "first", "surname" => "Datta")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Attempts at automating journal subject classification")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "5d14ffacb9ac4e20bdc0d9248df4e80d", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Humanities")
    end

    it "json_feed_item with references" do
      input = "https://rogue-scholar.org/api/posts/954f8138-0ecd-4090-87c5-cef1297f1470"
      subject = described_class.new(input: input)

      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.54900/zwm7q-vet94")
      expect(subject.url).to eq("https://upstream.force11.org/the-research-software-alliance-resa")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "954f8138-0ecd-4090-87c5-cef1297f1470", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "The Research Software Alliance (ReSA)" }])
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("familyName" => "Katz", "givenName" => "Daniel S.", "id" => "https://orcid.org/0000-0001-5934-7525", "type" => "Person")
      expect(subject.subjects).to eq([{ "subject" => "Humanities" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Humanities",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.references.length).to eq(11)
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(2)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("ORCID" => "https://orcid.org/0000-0001-5934-7525", "contributor_role" => "author", "given_name" => "Daniel S.", "sequence" => "first", "surname" => "Katz")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("The Research Software Alliance (ReSA)")
      expect(crossref_xml.dig("citation_list", "citation").last).to eq("article_title" => "The Research Software Alliance (ReSA) and the community landscape", "cYear" => "2020", "doi" => "10.5281/zenodo.3699950", "key" => "ref11")
      expect(crossref_xml.dig("citation_list", "citation").last).to eq("article_title" => "The Research Software Alliance (ReSA) and the community landscape", "cYear" => "2020", "doi" => "10.5281/zenodo.3699950", "key" => "ref11")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "954f81380ecd409087c5cef1297f1470", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Humanities")
    end

    it "json_feed_item from rogue scholar with doi" do
      input = "https://rogue-scholar.org/api/posts/1c578558-1324-4493-b8af-84c49eabc52f"
      subject = described_class.new(input: input, doi: "10.59350/9ry27-7cz42")

      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/9ry27-7cz42")
      expect(subject.url).to eq("https://wisspub.net/2023/05/23/eu-mitgliedstaaten-betonen-die-rolle-von-wissenschaftsgeleiteten-open-access-modellen-jenseits-von-apcs")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "EU-Mitgliedstaaten betonen die Rolle von wissenschaftsgeleiteten Open-Access-Modellen jenseits von APCs" }])
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName" => "Pampel", "givenName" => "Heinz", "id" => "https://orcid.org/0000-0003-3334-2771", "type" => "Person")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("de")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("ORCID" => "https://orcid.org/0000-0003-3334-2771", "contributor_role" => "author", "given_name" => "Heinz", "sequence" => "first", "surname" => "Pampel")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("EU-Mitgliedstaaten betonen die Rolle von wissenschaftsgeleiteten Open-Access-Modellen jenseits von APCs")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "1c57855813244493b8af84c49eabc52f", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Social sciences")
    end

    it "json_feed_item from rogue scholar with organizational author" do
      input = "https://rogue-scholar.org/api/posts/5561f8e4-2ff1-4186-a8d5-8dacb3afe414"
      subject = described_class.new(input: input, doi: "10.59350/9ry27-7cz42")

      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/9ry27-7cz42")
      expect(subject.url).to eq("https://libscie.org/ku-leuven-supports-researchequals")
      expect(subject.type).to eq("Article")
      expect(subject.titles).to eq([{ "title" => "KU Leuven supports ResearchEquals" }])
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("id" => "https://ror.org/0342dzm54", "name" => "Liberate Science", "type" => "Organization")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "organization")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "organization")).first).to eq("__content__" => "Liberate Science", "contributor_role" => "author", "sequence" => "first")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("KU Leuven supports ResearchEquals")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "5561f8e42ff14186a8d58dacb3afe414", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Social sciences")
    end

    it "json_feed_item from rogue scholar with relations" do
      input = "https://rogue-scholar.org/api/posts/8a4de443-3347-4b82-b57d-e3c82b6485fc"
      subject = described_class.new(input: input, doi: "10.53731/r79v4e1-97aq74v-ag578")

      expect(subject.id).to eq("https://doi.org/10.53731/r79v4e1-97aq74v-ag578")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/differences-between-orcid-and-datacite-metadata")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "8a4de443-3347-4b82-b57d-e3c82b6485fc", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName" => "Fenner",
           "givenName" => "Martin",
           "id" => "https://orcid.org/0000-0003-1419-2405", "type" => "Person")
      expect(subject.titles).to eq([{ "title" => "Differences between ORCID and DataCite Metadata" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2015-09-18", "updated" => "2023-09-05")
      expect(subject.descriptions.first["description"]).to start_with("One of the first tasks for DataCite in the European Commission-funded THOR project")
      expect(subject.publisher).to eq("name" => "Front Matter")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io", "identifierType" => "URL", "title" => "Front Matter", "type" => "Periodical")
      expect(subject.references).to eq([{"doi"=>"https://doi.org/10.5281/ZENODO.30799", "key"=>"ref1", "publicationYear"=>"2015", "title"=>"D2.1: Artefact, Contributor, And Organisation Relationship Data Schema"}])
      expect(subject.related_identifiers).to eq([{"id"=>"https://doi.org/10.5438/bc11-cqw1", "type"=>"IsIdenticalTo"}])
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq({"ORCID"=>"https://orcid.org/0000-0003-1419-2405", "contributor_role"=>"author", "given_name"=>"Martin", "sequence"=>"first", "surname"=>"Fenner"})
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Differences between ORCID and DataCite Metadata")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "8a4de44333474b82b57de3c82b6485fc", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Computer and information sciences")
    end

    it "json_feed_item from rogue scholar with anonymous author" do
      input = "https://rogue-scholar.org/api/posts/a163e340-5b3c-4736-9ab0-8c54fdff6a3c"
      subject = described_class.new(input: input, doi: "10.59350/9ry27-7cz42")

      expect(subject.id).to eq("https://doi.org/10.59350/9ry27-7cz42")
      expect(subject.url).to eq("https://lab.sub.uni-goettingen.de/welcome.html")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "a163e340-5b3c-4736-9ab0-8c54fdff6a3c", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName" => "Göbel", "givenName" => "Mathias", "type" => "Person")
      expect(subject.titles).to eq([{ "title" => "Welcome to the Lab" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2017-01-01", "updated" => "2017-01-01")
      expect(subject.descriptions.first["description"]).to start_with("Welcome everyone!")
      expect(subject.publisher).to eq("name" => "lab.sub - Articles")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://lab.sub.uni-goettingen.de", "identifierType" => "URL", "title" => "lab.sub - Articles", "type" => "Periodical")
      expect(subject.references).to be_nil
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig("doi_batch", "body", "posted_content")
      expect(Array.wrap(crossref_xml.dig("contributors", "person_name")).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig("contributors",
                                         "person_name")).first).to eq("contributor_role" => "author", "given_name" => "Mathias", "sequence" => "first", "surname" => "Göbel")
      expect(crossref_xml.dig("titles",
                              "title")).to eq("Welcome to the Lab")
      expect(crossref_xml.dig("item_number")).to eq("__content__" => "a163e3405b3c47369ab08c54fdff6a3c", "item_number_type" => "uuid")
      expect(crossref_xml.dig("group_title")).to eq("Computer and information sciences")
    end
  end
end
