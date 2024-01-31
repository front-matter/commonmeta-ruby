# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new }

  context "get json_feed_item metadata" do
    it "blogger post" do
      input = "https://api.rogue-scholar.org/posts/f3629c86-06e0-42c0-844a-266b03a91ef1"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/37y2z-gre70")
      expect(subject.url).to eq("https://iphylo.blogspot.com/2023/05/ten-years-and-million-links.html")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "f3629c86-06e0-42c0-844a-266b03a91ef1", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://orcid.org/0000-0002-7101-9767", "familyName" => "Page", "givenName" => "Roderic", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Ten years and a million links" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-05-31", "updated" => "2023-05-31")
      expect(subject.descriptions.first["description"]).to start_with("As trailed on a Twitter thread last week I’ve been working on a manuscript describing the efforts to map taxonomic names to their original descriptions in the taxonomic literature.")
      expect(subject.publisher).to eq("name" => "iPhylo")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://iphylo.blogspot.com", "identifierType" => "URL", "title" => "iPhylo", "type" => "Periodical")
    end

    it "ghost post with doi" do
      input = "https://api.rogue-scholar.org/posts/5bb66e92-5cb9-4659-8aca-20e486b695c9"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/4nwxn-frt36")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/does-it-compose")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.53731/4nwxn-frt36.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "5bb66e92-5cb9-4659-8aca-20e486b695c9", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName" => "Fenner", "givenName" => "Martin", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Does it compose?" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-05-16", "updated" => "2023-06-18")
      expect(subject.descriptions.first["description"]).to start_with("One question I have increasingly asked myself in the past few years. Meaning Can I run this open source software using Docker containers and a Docker Compose file?")
      expect(subject.publisher).to eq("name" => "Front Matter")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io", "identifierType" => "URL", "title" => "Front Matter", "type" => "Periodical")
    end

    it "ghost post with related_identifiers" do
      input = "https://api.rogue-scholar.org/posts/8a4de443-3347-4b82-b57d-e3c82b6485fc"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/r79v4e1-97aq74v-ag578")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/differences-between-orcid-and-datacite-metadata")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.53731/r79v4e1-97aq74v-ag578.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "8a4de443-3347-4b82-b57d-e3c82b6485fc", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName" => "Fenner", "givenName" => "Martin", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Differences between ORCID and DataCite Metadata" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2015-09-18", "updated" => "2023-09-07")
      expect(subject.descriptions.first["description"]).to start_with("One of the first tasks for DataCite in the European Commission-funded THOR project")
      expect(subject.publisher).to eq("name" => "Front Matter")
      expect(subject.related_identifiers).to eq([{ "id" => "https://doi.org/10.5438/bc11-cqw1", "type" => "IsIdenticalTo" }])
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io", "identifierType" => "URL", "title" => "Front Matter", "type" => "Periodical")
    end

    it "ghost post with related_identifiers and link to peer-reviewed article" do
      input = "https://api.rogue-scholar.org/posts/2bdebfc5-e02e-42c2-90c5-e873e2d0435d"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/r294649-6f79289-8cw18")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/nine-simple-ways-to-make-it-easier-to-re-use-your-data")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.53731/r294649-6f79289-8cw18.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "2bdebfc5-e02e-42c2-90c5-e873e2d0435d", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName" => "Fenner", "givenName" => "Martin", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Nine simple ways to make it easier to (re)use your data" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2013-06-25", "updated" => "2023-09-07")
      expect(subject.descriptions.first["description"]).to start_with("This paper in markdown format was written by Ethan White et al.")
      expect(subject.publisher).to eq("name" => "Front Matter")
      expect(subject.related_identifiers).to eq([{ "id" => "https://doi.org/10.4033/iee.2013.6b.6.f", "type" => "IsPreprintOf" }])
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io", "identifierType" => "URL", "title" => "Front Matter", "type" => "Periodical")
    end

    it "ghost post with related_identifiers and funding" do
      input = "https://api.rogue-scholar.org/posts/e58dc9c8-b870-4db2-8896-238b3246c551"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/r79s4nh-97aq74v-ag4t1")
      expect(subject.url).to eq("https://blog.front-matter.io/posts/tracking-the-growth-of-the-pid-graph")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.53731/r79s4nh-97aq74v-ag4t1.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "e58dc9c8-b870-4db2-8896-238b3246c551", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName" => "Fenner", "givenName" => "Martin", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Tracking the Growth of the PID Graph" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2019-07-01", "updated" => "2023-09-07")
      expect(subject.descriptions.first["description"]).to start_with("The connections between scholarly resources generated by persistent identifiers (PIDs)")
      expect(subject.publisher).to eq("name" => "Front Matter")
      expect(subject.funding_references).to eq([{ "awardNumber" => "777523", "funderIdentifier" => "http://doi.org/10.13039/501100000780", "funderName" => "European Commission" }])
      expect(subject.related_identifiers).to eq([{ "id" => "https://doi.org/10.5438/bv9z-dc66", "type" => "IsIdenticalTo" }])
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.front-matter.io", "identifierType" => "URL", "title" => "Front Matter", "type" => "Periodical")
    end

    it "ghost post without doi" do
      input = "https://api.rogue-scholar.org/posts/c3095752-2af0-40a4-a229-3ceb7424bce2"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/kj95y-gp867")
      expect(subject.url).to eq("https://www.ideasurg.pub/residency-visual-abstract")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "c3095752-2af0-40a4-a229-3ceb7424bce2", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Sathe", "givenName" => "Tejas S.",
                                               "id" => "https://orcid.org/0000-0003-0449-4469", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "The Residency Visual Abstract" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-04-08", "updated" => "2023-04-08")
      expect(subject.descriptions.first["description"]).to start_with("My prototype for a Residency Visual Abstract")
      expect(subject.publisher).to eq("name" => "I.D.E.A.S.")
      expect(subject.subjects).to eq([{ "subject" => "Clinical medicine" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Clinical medicine",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://www.ideasurg.pub", "identifierType" => "URL", "title" => "I.D.E.A.S.", "type" => "Periodical")
    end

    it "ghost post with author name suffix" do
      input = "https://api.rogue-scholar.org/posts/153d65e1-f0e4-49a6-a969-33d2129800ba"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/ytvy2-59450")
      expect(subject.url).to eq("https://www.ideasurg.pub/academic-powerhouse")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "153d65e1-f0e4-49a6-a969-33d2129800ba", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Sathe", "givenName" => "Tejas S.", "type" => "Person", "contributorRoles" => ["Author"],
                                               "id" => "https://orcid.org/0000-0003-0449-4469")
      expect(subject.titles).to eq([{ "title" => "How to Build an Academic Powerhouse: Let's Study Who's Doing it" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-06-03", "updated" => "2023-06-03")
      expect(subject.descriptions.first["description"]).to start_with("Students and residents aspiring for a career in academic surgery")
      expect(subject.publisher).to eq("name" => "I.D.E.A.S.")
      expect(subject.subjects).to eq([{ "subject" => "Clinical medicine" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Clinical medicine",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://www.ideasurg.pub", "identifierType" => "URL", "title" => "I.D.E.A.S.", "type" => "Periodical")
      expect(subject.references).to be_nil
    end

    it "medium post with institutional author" do
      input = "https://api.rogue-scholar.org/posts/05f01f68-ef81-47d7-a3c1-40aba91d358f"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/jhrs4-22440")
      expect(subject.url).to eq("https://medium.com/@researchgraph/unveiling-the-synergy-retrieval-augmented-generation-rag-meets-knowledge-graphs-fc0a6900f7eb")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "05f01f68-ef81-47d7-a3c1-40aba91d358f", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("contributorRoles"=>["Author"], "name"=>"Research Graph", "type"=>"Organization")
      expect(subject.titles).to eq([{ "title" => "Unveiling the Synergy: Retrieval Augmented Generation (RAG) Meets Knowledge Graphs" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published"=>"2024-01-18", "updated"=>"2024-01-18")
      expect(subject.descriptions.first["description"]).to start_with("<strong> Tools and Platform for Integration of Knowledge Graph with RAG pipelines.")
      expect(subject.publisher).to eq("name" => "Research Graph")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://medium.com/@researchgraph", "identifierType" => "URL", "title" => "Research Graph", "type" => "Periodical")
      expect(subject.references).to be_nil
    end

    it "syldavia gazette post with references" do
      input = "https://api.rogue-scholar.org/posts/0022b9ef-525a-4a79-81ad-13411697f58a"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.53731/ffbx660-083tnag")
      expect(subject.url).to eq("https://syldavia-gazette.org/guinea-worms-chatgpt-neanderthals")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.53731/ffbx660-083tnag.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "0022b9ef-525a-4a79-81ad-13411697f58a", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Fenner", "givenName" => "Martin", "id" => "https://orcid.org/0000-0003-1419-2405", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Guinea Worms, ChatGPT, Neanderthals, Plagiarism, Tidyverse" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-02-01", "updated" => "2023-04-13")
      expect(subject.descriptions.first["description"]).to start_with("Guinea worm disease reaches all-time low: only 13* human cases")
      expect(subject.publisher).to eq("name" => "Syldavia Gazette")
      expect(subject.subjects).to eq([{ "subject" => "Humanities" }, { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf", "subject" => "FOS: Humanities", "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://syldavia-gazette.org", "identifierType" => "URL", "title" => "Syldavia Gazette", "type" => "Periodical")
      expect(subject.references.length).to eq(5)
      expect(subject.references[1]).to eq("doi" => "https://doi.org/10.1126/science.adg7879", "key" => "ref2", "publicationYear" => "2023", "title" => "ChatGPT is fun, but not an author")
    end

    it "wordpress post" do
      input = "https://api.rogue-scholar.org/posts/1c578558-1324-4493-b8af-84c49eabc52f"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/kz04m-s8z58")
      expect(subject.url).to eq("https://wisspub.net/2023/05/23/eu-mitgliedstaaten-betonen-die-rolle-von-wissenschaftsgeleiteten-open-access-modellen-jenseits-von-apcs")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/kz04m-s8z58.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "1c578558-1324-4493-b8af-84c49eabc52f", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Pampel", "givenName" => "Heinz", "id" => "https://orcid.org/0000-0003-3334-2771", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "EU-Mitgliedstaaten betonen die Rolle von wissenschaftsgeleiteten Open-Access-Modellen jenseits von APCs" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-05-23", "updated" => "2023-05-23")
      expect(subject.descriptions.first["description"]).to start_with("Die EU-Wissenschaftsministerien haben sich auf ihrer heutigen Sitzung in Brüssel unter dem Titel “Council conclusions on high-quality, transparent, open, trustworthy and equitable scholarly publishing”")
      expect(subject.publisher).to eq("name" => "wisspub.net")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("de")
      expect(subject.container).to eq("identifier" => "https://wisspub.net", "identifierType" => "URL", "title" => "wisspub.net", "type" => "Periodical")
    end

    it "archived wordpress post" do
      input = "https://api.rogue-scholar.org/posts/570c8129-e867-49e6-8517-bd783627e76e"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/faeph-x4x84")
      expect(subject.url).to eq("https://wayback.archive-it.org/22143/20231103191454/https://project-thor.eu/2016/08/10/orcid-integration-in-pangaea")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/faeph-x4x84.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "570c8129-e867-49e6-8517-bd783627e76e", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("contributorRoles" => ["Author"],
                                               "type" => "Person",
                                               "familyName" => "Stocker",
                                               "givenName" => "Markus",
                                               "id" => "https://orcid.org/0000-0001-5492-3212")
      expect(subject.titles).to eq([{ "title" => "ORCID Integration Series: PANGAEA" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2016-08-10", "updated" => "2016-08-10")
      expect(subject.descriptions.first["description"]).to start_with("This is the first in a series of posts describing how THOR partners")
      expect(subject.publisher).to eq("name" => "Project THOR")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.funding_references).to eq([{ "awardNumber" => "654039", "funderIdentifier" => "https://doi.org/10.13039/501100007601", "funderIdentifierType" => "Crossref Funder ID", "funderName" => "European Union’s Horizon 2020 research and innovation programme" }])
      expect(subject.container).to eq("identifier" => "https://project-thor.eu", "identifierType" => "URL", "title" => "Project THOR", "type" => "Periodical")
      expect(subject.archive_locations).to eq(["Internet Archive"])
    end

    it "wordpress post with references" do
      input = "https://api.rogue-scholar.org/posts/4e4bf150-751f-4245-b4ca-fe69e3c3bb24"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/hke8v-d1e66")
      expect(subject.url).to eq("https://svpow.com/2023/06/09/new-paper-curtice-et-al-2023-on-the-first-haplocanthosaurus-from-dry-mesa")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/hke8v-d1e66.pdf")
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Wedel", "givenName" => "Matt", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "New paper: Curtice et al. (2023) on the first <i>Haplocanthosaurus</i> from Dry Mesa" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-06-09", "updated" => "2023-06-09")
      expect(subject.descriptions.first["description"]).to start_with("Brian Curtice and Colin Boisvert are presenting our talk on this project")
      expect(subject.publisher).to eq("name" => "Sauropod Vertebra Picture of the Week")
      expect(subject.subjects).to eq([{ "subject" => "Earth and related environmental sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Earth and related environmental sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://svpow.com", "identifierType" => "URL", "title" => "Sauropod Vertebra Picture of the Week", "type" => "Periodical")
      expect(subject.references.length).to eq(3)
      expect(subject.references.first).to eq("key" => "ref1", "url" => "https://sauroposeidon.files.wordpress.com/2010/04/foster-and-wedel-2014-haplocanthosaurus-from-snowmass-colorado.pdf")
    end

    it "wordpress post with tracking code on url" do
      input = "https://api.rogue-scholar.org/posts/5d95d90d-ff59-4c8b-b7f8-44e6b45fd593"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/tpa8t-j6292")
      expect(subject.url).to eq("https://www.samuelmoore.org/2023/04/20/how-to-cultivate-good-closures-scaling-small-and-the-limits-of-openness")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/tpa8t-j6292.pdf")
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Moore", "givenName" => "Samuel", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "How to cultivate good closures: ‘scaling small’ and the limits of openness" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-04-20", "updated" => "2023-06-19")
      expect(subject.descriptions.first["description"]).to start_with("<em>Text of a talk given to the COPIM end-of-project conference:")
      expect(subject.publisher).to eq("name" => "Samuel Moore")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://www.samuelmoore.org", "identifierType" => "URL", "title" => "Samuel Moore", "type" => "Periodical")
      expect(subject.references).to be_nil
    end

    it "ghost post with institutional author" do
      input = "https://api.rogue-scholar.org/posts/2b3cdd27-5123-4167-9482-3c074392e2d2"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/tfahc-rp566")
      expect(subject.url).to eq("https://blog.oa.works/nature-features-oa-reports-work-putting-oa-policy-into-practice")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/tfahc-rp566.pdf")
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("name" => "OA.Works", "type" => "Organization", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Nature features OA.Report's work putting OA policy into practice!" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-01-24", "updated" => "2023-10-01")
      expect(subject.descriptions.first["description"]).to start_with("After a couple of years of working to support institutions implementing their OA policies")
      expect(subject.publisher).to eq("name" => "OA.Works Blog")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://blog.oa.works", "identifierType" => "URL", "title" => "OA.Works Blog", "type" => "Periodical")
    end

    it "upstream post with references" do
      input = "https://api.rogue-scholar.org/posts/954f8138-0ecd-4090-87c5-cef1297f1470"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.54900/zwm7q-vet94")
      expect(subject.url).to eq("https://upstream.force11.org/the-research-software-alliance-resa")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "954f8138-0ecd-4090-87c5-cef1297f1470", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(2)
      expect(subject.contributors.first).to eq("familyName" => "Katz", "givenName" => "Daniel S.", "id" => "https://orcid.org/0000-0001-5934-7525", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "The Research Software Alliance (ReSA)" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-04-18", "updated" => "2023-04-18")
      expect(subject.descriptions.first["description"]).to start_with("Research software is a key part of most research today.")
      expect(subject.publisher).to eq("name" => "Upstream")
      expect(subject.subjects).to eq([{ "subject" => "Humanities" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Humanities",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://upstream.force11.org", "identifierType" => "URL", "title" => "Upstream", "type" => "Periodical")
      expect(subject.references.length).to eq(11)
      expect(subject.references.first).to eq("key" => "ref1", "url" => "https://software.ac.uk/blog/2014-12-04-its-impossible-conduct-research-without-software-say-7-out-10-uk-researchers")
    end

    it "jekyll post" do
      input = "https://api.rogue-scholar.org/posts/efdacb04-bcec-49d7-b689-ab3eab0634bf"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/zwdq7-waa43")
      expect(subject.url).to eq("https://citationstyles.org/2020/07/11/seeking-public-comment-on-CSL-1-0-2")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/zwdq7-waa43.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "efdacb04-bcec-49d7-b689-ab3eab0634bf", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(0)
      # expect(subject.contributors.first).to eq("familyName" => "Karcher", "givenName" => "Sebastian",
      #                                          "id" => "https://orcid.org/0000-0001-8249-7388", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Seeking Public Comment on CSL 1.0.2 Release" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2020-07-11", "updated" => "2020-07-11")
      expect(subject.descriptions.first["description"]).to start_with("Over the past few months, Citation Style Language developers have worked to address a backlog of feature requests. This work will be reflected in two upcoming releases.")
      expect(subject.publisher).to eq("name" => "Citation Style Language")
      expect(subject.subjects).to eq([{ "subject" => "Computer and information sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Computer and information sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://citationstyles.org", "identifierType" => "URL", "title" => "Citation Style Language", "type" => "Periodical")
    end

    it "ghost post with organizational author" do
      input = "https://api.rogue-scholar.org/posts/5561f8e4-2ff1-4186-a8d5-8dacb3afe414"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/2shz7-ehx26")
      expect(subject.url).to eq("https://libscie.org/ku-leuven-supports-researchequals")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/2shz7-ehx26.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "5561f8e4-2ff1-4186-a8d5-8dacb3afe414", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("id" => "https://ror.org/0342dzm54", "name" => "Liberate Science", "type" => "Organization", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "KU Leuven supports ResearchEquals" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-05-09", "updated" => "2023-05-09")
      expect(subject.descriptions.first["description"]).to start_with("KU Leuven is now an inaugural supporting member of ResearchEquals")
      expect(subject.publisher).to eq("name" => "Liberate Science")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://libscie.org", "identifierType" => "URL", "title" => "Liberate Science", "type" => "Periodical")
      expect(subject.references).to be_nil
    end

    it "jekyll post with anonymous author" do
      input = "https://api.rogue-scholar.org/posts/a163e340-5b3c-4736-9ab0-8c54fdff6a3c"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/33es7-fqz31")
      expect(subject.url).to eq("https://lab.sub.uni-goettingen.de/welcome.html")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/33es7-fqz31.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "a163e340-5b3c-4736-9ab0-8c54fdff6a3c", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Göbel", "givenName" => "Mathias", "type" => "Person", "contributorRoles" => ["Author"])
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
    end

    it "blog post with non-url id" do
      input = "https://api.rogue-scholar.org/posts/1898d2d7-4d87-4487-96c4-3073cf99e9a5"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/63055-a8604")
      expect(subject.url).to eq("http://sfmatheson.blogspot.com/2023/01/quintessence-of-dust-2023-restart-why.html")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/63055-a8604.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "1898d2d7-4d87-4487-96c4-3073cf99e9a5", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Matheson", "givenName" => "Stephen", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Quintessence of Dust 2023 restart: the why" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-01-09", "updated" => "2023-04-02")
      expect(subject.descriptions.first["description"]).to start_with("It's early January 2023, a little before sunset in Tucson.")
      expect(subject.publisher).to eq("name" => "Quintessence of Dust")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "http://sfmatheson.blogspot.com", "identifierType" => "URL", "title" => "Quintessence of Dust", "type" => "Periodical")
      expect(subject.references).to be_nil
    end

    it "wordpress post with many references" do
      input = "https://api.rogue-scholar.org/posts/f3dc29da-0481-4f3b-8110-4c07260fca67"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/9gfjs-pey70")
      expect(subject.url).to eq("https://flavoursofopen.science/grundlagen-fur-die-entwicklung-einer-open-scholarship-strategie")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/9gfjs-pey70.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "f3dc29da-0481-4f3b-8110-4c07260fca67", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Steiner", "givenName" => "Tobias", "id" => "https://orcid.org/0000-0002-3158-3136", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "Grundlagen für die Entwicklung einer Open Scholarship-Strategie" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2019-01-30", "updated" => "2023-07-08")
      expect(subject.descriptions.first["description"]).to start_with("<strong>Versionshistorie</strong> Version 1.0 — 16. Oktober 2017")
      expect(subject.publisher).to eq("name" => "Flavours of Open")
      expect(subject.subjects).to eq([{ "subject" => "Humanities" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Humanities",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://flavoursofopen.science", "identifierType" => "URL", "title" => "Flavours of Open", "type" => "Periodical")
      expect(subject.references.length).to eq(56)
      expect(subject.references.first).to eq("key" => "ref1", "url" => "http://oerstrategy.org/home/read-the-doc")
    end

    it "substack post with broken reference" do
      input = "https://api.rogue-scholar.org/posts/2b105b29-acbc-4eae-9ff1-368803f36a4d"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.59350/bbcsr-r4b59")
      expect(subject.url).to eq("https://markrubin.substack.com/p/the-preregistration-prescriptiveness")
      expect(subject.files.length).to eq(4)
      expect(subject.files[1]).to eq("mimeType" => "application/pdf", "url" => "https://api.rogue-scholar.org/posts/10.59350/bbcsr-r4b59.pdf")
      expect(subject.alternate_identifiers).to eq([{ "alternateIdentifier" => "2b105b29-acbc-4eae-9ff1-368803f36a4d", "alternateIdentifierType" => "UUID" }])
      expect(subject.type).to eq("Article")
      expect(subject.contributors.length).to eq(1)
      expect(subject.contributors.first).to eq("familyName" => "Rubin", "givenName" => "Mark", "type" => "Person", "contributorRoles" => ["Author"])
      expect(subject.titles).to eq([{ "title" => "The Preregistration Prescriptiveness Trade-Off and Unknown Unknowns in Science" }])
      expect(subject.license).to eq("id" => "CC-BY-4.0",
                                    "url" => "https://creativecommons.org/licenses/by/4.0/legalcode")
      expect(subject.date).to eq("published" => "2023-06-06", "updated" => "2023-06-06")
      expect(subject.descriptions.first["description"]).to start_with("<strong>Abstract</strong> I discuss Van Drimmelen’s (2023) Metascience2023")
      expect(subject.publisher).to eq("name" => "Critical Metascience")
      expect(subject.subjects).to eq([{ "subject" => "Social sciences" },
                                      { "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
                                        "subject" => "FOS: Social sciences",
                                        "subjectScheme" => "Fields of Science and Technology (FOS)" }])
      expect(subject.language).to eq("en")
      expect(subject.container).to eq("identifier" => "https://markrubin.substack.com", "identifierType" => "URL", "title" => "Critical Metascience", "type" => "Periodical")
      expect(subject.references.length).to eq(16)
      expect(subject.references.first).to eq("doi" => "https://doi.org/10.3386/w27250", "key" => "ref1", "publicationYear" => "2020", "title" => "Research Registries: Facts, Myths, and Possible Improvements")
    end
  end

  context "get json_feed", vcr: true do
    it "unregistered posts" do
      response = subject.get_json_feed_unregistered
      expect(response).to eq("17d0e31c-bc41-42b8-b873-d3dacee61f5c")
    end

    it "updated posts" do
      response = subject.get_json_feed_updated
      expect(response).to eq("bb8932b9-2820-42f8-b22f-f191aaf00e32")
    end

    it "by blog_id" do
      response = subject.get_json_feed_by_blog("iphylo")
      expect(response).to eq("3749f8c4-1ba7-4e51-9dd6-9d9551ad451a")
    end
  end

  context "get doi_prefix for blog", vcr: true do
    it "by blog_id" do
      response = subject.get_doi_prefix_by_blog_slug("iphylo")
      expect(response).to eq("10.59350")
    end

    it "by blog post id" do
      response = subject.get_doi_prefix_by_json_feed_item_id("1898d2d7-4d87-4487-96c4-3073cf99e9a5")
      expect(response).to eq("10.59350")
    end

    it "by blog post id specific prefix" do
      response = subject.get_doi_prefix_by_json_feed_item_id("2b22bbba-bcba-4072-94cc-3f88442fff88")
      expect(response).to eq("10.54900")
    end
  end

  context "get blog_id for json_feed item id", vcr: true do
    it "by blog post id" do
      response = subject.get_json_feed_blog_slug("1898d2d7-4d87-4487-96c4-3073cf99e9a5")
      expect(response).to eq("sfmatheson")
    end

    it "not found" do
      response = subject.get_doi_prefix_by_json_feed_item_id("2b22bbba-bcba-4072-94cc-3f88442fff55")
      expect(response).to eq(nil)
    end
  end
end
