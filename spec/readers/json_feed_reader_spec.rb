# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new }

  context 'get json_feed_item metadata' do
    it 'blogger post' do
      input = 'https://rogue-scholar.org/api/posts/1jgo59el'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://iphylo.blogspot.com/2023/05/ten-years-and-million-links.html')
      expect(subject.url).to eq('https://iphylo.blogspot.com/2023/05/ten-years-and-million-links.html')
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Page", "givenName"=>"Roderic", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Ten years and a million links"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-31')
      expect(subject.descriptions).to eq([{"description"=>"As trailed on a Twitter thread last week I’ve been working on a manuscript describing the efforts to map taxonomic names to their original descriptions in the taxonomic literature. Putting together a...", "descriptionType"=>"Abstract"}])
      expect(subject.publisher).to eq('name' => 'iPhylo')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://iphylo.blogspot.com/", "identifierType"=>"URL", "title"=>"iPhylo", "type"=>"Periodical")
    end

    it 'ghost post with doi' do
      input = 'https://rogue-scholar.org/api/posts/1jgo8yel'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/4nwxn-frt36')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/does-it-compose')
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("id" => "https://orcid.org/0000-0003-1419-2405", "familyName"=>"Fenner", "givenName"=>"Martin", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Does it compose?"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-16', 'updated' => '2023-05-16')
      expect(subject.descriptions).to eq([{"description"=>"One question I have increasingly asked myself in the past few years. Meaning Can I run this open source software using Docker containers and a Docker Compose file?As the Docker project turned ten this...", "descriptionType"=>"Abstract"}])
      expect(subject.publisher).to eq('name' => 'Front Matter')
      expect(subject.subjects).to eq([{"subject"=>"news"}])
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://blog.front-matter.io/", "identifierType"=>"URL", "title"=>"Front Matter", "type"=>"Periodical")
    end

    it 'wordpress post' do
      input = 'https://rogue-scholar.org/api/posts/zkevlyd3'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://wisspub.net/2023/05/23/eu-mitgliedstaaten-betonen-die-rolle-von-wissenschaftsgeleiteten-open-access-modellen-jenseits-von-apcs')
      expect(subject.url).to eq('https://wisspub.net/2023/05/23/eu-mitgliedstaaten-betonen-die-rolle-von-wissenschaftsgeleiteten-open-access-modellen-jenseits-von-apcs')
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Pampel", "givenName"=>"Heinz", "id"=>"https://orcid.org/0000-0003-3334-2771", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"EU-Mitgliedstaaten betonen die Rolle von wissenschaftsgeleiteten Open-Access-Modellen jenseits von APCs"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2023-05-23', 'updated' => '2023-05-23')
      expect(subject.descriptions).to eq([{"description"=>"Die EU-Wissenschaftsministerien haben sich auf ihrer heutigen Sitzung in Brüssel unter dem Titel “Council conclusions on high-quality, transparent, open, trustworthy and equitable scholarly publishing” (PDF...", "descriptionType"=>"Abstract"}])
      expect(subject.publisher).to eq('name' => 'wisspub.net')
      expect(subject.subjects).to eq([{"subject"=>"open access"}, {"subject"=>"open access transformation"}, {"subject"=>"open science"}, {"subject"=>"eu"}])
      expect(subject.language).to eq('de')
      expect(subject.container).to eq("identifier"=>"https://wisspub.net/", "identifierType"=>"URL", "title"=>"wisspub.net", "type"=>"Periodical")
    end
    
    it 'jekyll post' do
      input = 'https://rogue-scholar.org/api/posts/1jdkwod5'
      subject = described_class.new(input: input)
      puts subject.errors
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://citationstyles.org/2020/07/11/seeking-public-comment-on-CSL-1-0-2')
      expect(subject.url).to eq('https://citationstyles.org/2020/07/11/seeking-public-comment-on-CSL-1-0-2')
      expect(subject.type).to eq('Article')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Karcher", "givenName"=>"Sebastian", "type"=>"Person")
      expect(subject.titles).to eq([{"title"=>"Seeking Public Comment on CSL 1.0.2 Release"}])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2020-07-11', 'updated' => '2020-07-11')
      expect(subject.descriptions).to eq([{"description"=>"Over the past few months, Citation Style Language developers have worked to address a backlog of feature requests. This work will be reflected in two upcoming releases. The first of these, 1.0.2, is slated...", "descriptionType"=>"Abstract"}])
      expect(subject.publisher).to eq('name' => 'Citation Style Language')
      expect(subject.subjects).to be_nil
      expect(subject.language).to eq('en')
      expect(subject.container).to eq("identifier"=>"https://citationstyles.org/", "identifierType"=>"URL", "title"=>"Citation Style Language", "type"=>"Periodical")
    end 
  end

  context 'get json_feed' do
    it 'front-matter blog' do
      id = 'f0m0e38'
      response = subject.get_json_feed(id)
      expect(response).to be_nil
    end

    it 'upstream' do
      id = 'pm0p222'
      response = subject.get_json_feed(id)
      expect(response).to be_nil
    end

    it 'citation style language' do
      id = 'prmb582'
      response = subject.get_json_feed(id)
      expect(response).to eq("1jdkoe52,4qe9ypg1,1jdkwod5,56glp9d9,1xdnk0d0,56glmmd9,1xdnoje0,31epl0dn,q0dqm6go")
    end
  end
end
