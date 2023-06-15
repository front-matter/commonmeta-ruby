# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new }

  context 'get json_feed_item metadata' do
    it 'blogger post' do
      input = 'https://rogue-scholar.org/api/posts/f3629c86-06e0-42c0-844a-266b03a91ef1'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://iphylo.blogspot.com/2023/05/ten-years-and-million-links.html')
      expect(subject.url).to eq('https://iphylo.blogspot.com/2023/05/ten-years-and-million-links.html')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"f3629c86-06e0-42c0-844a-266b03a91ef1", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Page", "givenName"=>"Roderic", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Ten years and a million links"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-31')
      expect(subject.descriptions.first['description']).to start_with("As trailed on a Twitter thread last week I’ve been working on a manuscript describing the efforts to map taxonomic names to their original descriptions in the taxonomic literature.")
      expect(subject.publisher).to eq('name' => 'iPhylo')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://iphylo.blogspot.com/", "identifierType"=>"URL", "title"=>"iPhylo", "type"=>"Periodical")
    end

    it 'ghost post with doi' do
      input = 'https://rogue-scholar.org/api/posts/5bb66e92-5cb9-4659-8aca-20e486b695c9'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/4nwxn-frt36')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/does-it-compose')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"5bb66e92-5cb9-4659-8aca-20e486b695c9", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName"=>"Fenner", "givenName"=>"Martin", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Does it compose?"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-16', 'updated' => '2023-05-16')
      expect(subject.descriptions.first['description']).to start_with("One question I have increasingly asked myself in the past few years. Meaning Can I run this open source software using Docker containers and a Docker Compose file?")
      expect(subject.publisher).to eq('name' => 'Front Matter')
      expect(subject.subjects).to eq([{"subject"=>"news"}])
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://blog.front-matter.io", "identifierType"=>"URL", "title"=>"Front Matter", "type"=>"Periodical")
    end

    it 'ghost post without doi' do
      input = 'https://rogue-scholar.org/api/posts/c3095752-2af0-40a4-a229-3ceb7424bce2'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://www.ideasurg.pub/residency-visual-abstract')
      expect(subject.url).to eq('https://www.ideasurg.pub/residency-visual-abstract')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"c3095752-2af0-40a4-a229-3ceb7424bce2", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Sathe", "givenName"=>"Tejas S.", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"The Residency Visual Abstract"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-04-08')
      expect(subject.descriptions.first['description']).to start_with("A graphical, user-friendly tool for programs to highlight important data to prospective applicants")
      expect(subject.publisher).to eq('name' => 'I.D.E.A.S.')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://www.ideasurg.pub/", "identifierType"=>"URL", "title"=>"I.D.E.A.S.", "type"=>"Periodical")
    end

    it 'ghost post with author name suffix' do
      input = 'https://rogue-scholar.org/api/posts/6179ad80-cc7f-4904-9260-0ecb3c3a90ba'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://www.ideasurg.pub/academic-powerhouse')
      expect(subject.url).to eq('https://www.ideasurg.pub/academic-powerhouse')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"6179ad80-cc7f-4904-9260-0ecb3c3a90ba", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Sathe", "givenName"=>"Tejas S.", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"How to Build an Academic Powerhouse: Let's Study Who's Doing it"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-06-03')
      expect(subject.descriptions.first['description']).to start_with("A Data Exploration with Public Data from the Academic Surgical Congress")
      expect(subject.publisher).to eq('name' => 'I.D.E.A.S.')
      expect(subject.subjects).to eq([{"subject"=>"pre-print"}])
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://www.ideasurg.pub/", "identifierType"=>"URL", "title"=>"I.D.E.A.S.", "type"=>"Periodical")
      expect(subject.references).to be_nil
    end

    it 'syldavia gazette post with references' do
      input = 'https://rogue-scholar.org/api/posts/0022b9ef-525a-4a79-81ad-13411697f58a'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/ffbx660-083tnag')
      expect(subject.url).to eq('https://syldavia-gazette.org/guinea-worms-chatgpt-neanderthals')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"0022b9ef-525a-4a79-81ad-13411697f58a", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Fenner", "givenName"=>"Martin", "id"=>"https://orcid.org/0000-0003-1419-2405", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Guinea Worms, ChatGPT, Neanderthals, Plagiarism, Tidyverse"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-02-01', 'updated' => '2023-04-13')
      expect(subject.descriptions.first['description']).to start_with("Guinea worm disease reaches all-time low: only 13* human cases reported in 2022")
      expect(subject.publisher).to eq('name' => 'Syldavia Gazette')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://syldavia-gazette.org", "identifierType"=>"URL", "title"=>"Syldavia Gazette", "type"=>"Periodical")
      expect(subject.references.length).to eq(5)
      expect(subject.references.first).to eq("key"=>"ref1", "url"=>"https://cartercenter.org/news/pr/2023/2022-guinea-worm-worldwide-cases-announcement.html")
    end

    it 'wordpress post' do
      input = 'https://rogue-scholar.org/api/posts/1c578558-1324-4493-b8af-84c49eabc52f'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('http://wisspub.net/?p=20455')
      expect(subject.url).to eq('https://wisspub.net/2023/05/23/eu-mitgliedstaaten-betonen-die-rolle-von-wissenschaftsgeleiteten-open-access-modellen-jenseits-von-apcs')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"1c578558-1324-4493-b8af-84c49eabc52f", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Pampel", "givenName"=>"Heinz", "id"=>"https://orcid.org/0000-0003-3334-2771", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"EU-Mitgliedstaaten betonen die Rolle von wissenschaftsgeleiteten Open-Access-Modellen jenseits von APCs"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-23', 'updated' => '2023-05-23')
      expect(subject.descriptions.first['description']).to start_with("Die EU-Wissenschaftsministerien haben sich auf ihrer heutigen Sitzung in Brüssel unter dem Titel “Council conclusions on high-quality, transparent, open, trustworthy and equitable scholarly publishing”")
      expect(subject.publisher).to eq('name' => 'wisspub.net')
      expect(subject.subjects).to eq([{"subject"=>"open access"}, {"subject"=>"open access transformation"}, {"subject"=>"open science"}, {"subject"=>"eu"}])
      expect(subject.language).to eq('de')
      expect(subject.container).to eq("identifier"=>"https://wisspub.net", "identifierType"=>"URL", "title"=>"wisspub.net", "type"=>"Periodical")
    end

    it 'wordpress post with references' do
      input = 'https://rogue-scholar.org/api/posts/4e4bf150-751f-4245-b4ca-fe69e3c3bb24'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('http://svpow.com/?p=20992')
      expect(subject.url).to eq('https://svpow.com/2023/06/09/new-paper-curtice-et-al-2023-on-the-first-haplocanthosaurus-from-dry-mesa')
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Wedel", "givenName"=>"Matt", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"New paper: Curtice et al. (2023) on the first Haplocanthosaurus from Dry Mesa"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-06-09', 'updated' => '2023-06-09')
      expect(subject.descriptions.first['description']).to start_with("Haplocanthosaurus tibiae and dorsal vertebrae.")
      expect(subject.publisher).to eq('name' => 'Sauropod Vertebra Picture of the Week')
      expect(subject.subjects).to eq([{"subject"=>"#mte14"}, {"subject"=>"barosaurus"}, {"subject"=>"cervical"}, {"subject"=>"conferences"}, {"subject"=>"diplodocids"}])
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://svpow.com", "identifierType"=>"URL", "title"=>"Sauropod Vertebra Picture of the Week", "type"=>"Periodical")
      expect(subject.references.length).to eq(3)
      expect(subject.references.first).to eq("key"=>"ref1", "url"=>"https://sauroposeidon.files.wordpress.com/2010/04/foster-and-wedel-2014-haplocanthosaurus-from-snowmass-colorado.pdf")
    end

    it 'upstream post with references' do
      input = 'https://rogue-scholar.org/api/posts/954f8138-0ecd-4090-87c5-cef1297f1470'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.54900/zwm7q-vet94')
      expect(subject.url).to eq('https://upstream.force11.org/the-research-software-alliance-resa')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"954f8138-0ecd-4090-87c5-cef1297f1470", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("familyName"=>"Katz", "givenName"=>"Daniel S.", "id"=>"https://orcid.org/0000-0001-5934-7525", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"The Research Software Alliance (ReSA)"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-04-18', 'updated' => '2023-04-18')
      expect(subject.descriptions.first['description']).to start_with("Research software is a key part of most research today. As University of Manchester Professor Carole Goble has said, \"software is the ubiquitous instrument of science.\"")
      expect(subject.publisher).to eq('name' => 'Upstream')
      expect(subject.subjects).to eq([{"subject"=>"news"}])
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://upstream.force11.org", "identifierType"=>"URL", "title"=>"Upstream", "type"=>"Periodical")
      expect(subject.references.length).to eq(11)
      expect(subject.references.first).to eq("key"=>"ref1", "url"=>"https://software.ac.uk/blog/2014-12-04-its-impossible-conduct-research-without-software-say-7-out-10-uk-researchers")
    end

    it 'jekyll post' do
      input = 'https://rogue-scholar.org/api/posts/efdacb04-bcec-49d7-b689-ab3eab0634bf'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://citationstyles.org/2020/07/11/seeking-public-comment-on-CSL-1-0-2')
      expect(subject.url).to eq('https://citationstyles.org/2020/07/11/seeking-public-comment-on-CSL-1-0-2')
      expect(subject.alternate_identifiers).to eq([{"alternateIdentifier"=>"efdacb04-bcec-49d7-b689-ab3eab0634bf", "alternateIdentifierType"=>"UUID"}])
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Karcher", "givenName"=>"Sebastian", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Seeking Public Comment on CSL 1.0.2 Release"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2020-07-11', 'updated' => '2020-07-11')
      expect(subject.descriptions.first['description']).to start_with("Over the past few months, Citation Style Language developers have worked to address a backlog of feature requests. This work will be reflected in two upcoming releases.")
      expect(subject.publisher).to eq('name' => 'Citation Style Language')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://citationstyles.org/", "identifierType"=>"URL", "title"=>"Citation Style Language", "type"=>"Periodical")
    end
  end

  context 'get json_feed' do
    it 'unregistered posts' do
      response = subject.get_json_feed_unregistered
      expect(response).to eq("ca2a7df4-f3b9-487c-82e9-27f54de75ea8")
    end

    it 'by blog_id' do
      response = subject.get_json_feed_by_blog('tyfqw20').split('\n')
      expect(response.length).to eq(25)
      expect(response.first).to eq("3e1278f6-e7c0-43e1-bb54-6829e1344c0d")
    end
  end
end
