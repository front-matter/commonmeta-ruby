# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  context 'write metadata as crossref' do
    it 'journal article' do
      input = "#{fixture_path}crossref.xml"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567')
      expect(subject.url).to eq('https://elifesciences.org/articles/01567')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('crossref_result', 'query_result',
                                                             'body', 'query', 'doi_record', 'crossref', 'journal')
      expect(crossref_xml.dig('journal_metadata', 'full_title')).to eq('eLife')
      expect(crossref_xml.dig('journal_article', 'doi_data', 'doi')).to eq('10.7554/eLife.01567')
      expect(crossref_xml.dig('journal_article', 'citation_list', 'citation').length).to eq(27)
      expect(crossref_xml.dig('journal_article', 'citation_list',
                              'citation').first).to eq('article_title' => 'APL regulates vascular tissue identity in Arabidopsis',
                                                       'author' => 'Bonke',
                                                       'cYear' => '2003',
                                                       'doi' => '10.1038/nature02100',
                                                       'first_page' => '181',
                                                       'journal_title' => 'Nature',
                                                       'key' => 'bib1',
                                                       'volume' => '426')
    end

    it 'posted_content' do
      subject = described_class.new(input: '10.1101/2020.12.01.406702')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1101/2020.12.01.406702')
      expect(subject.url).to eq('http://biorxiv.org/lookup/doi/10.1101/2020.12.01.406702')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(crossref_xml.dig('doi_data', 'doi')).to eq('10.1101/2020.12.01.406702')
      expect(crossref_xml.dig('doi_data', 'resource')).to eq('http://biorxiv.org/lookup/doi/10.1101/2020.12.01.406702')
    end

    it 'journal article from datacite' do
      input = '10.2312/geowissenschaften.1989.7.181'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["property '/descriptions/0' is missing required keys: description"])
      expect(subject.id).to eq('https://doi.org/10.2312/geowissenschaften.1989.7.181')
      expect(subject.url).to eq('https://www.tib.eu/suchen/id/awi:7058a56c5e43afd705af945d01536b9aaeeee491')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.titles).to eq([{ 'title' => 'An Overview of the Geology of Canadian Gold Occurrences' }])
      expect(subject.publisher).to eq('name' => 'VCH Verlagsgesellschaft mbH')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'journal',
                                                             'journal_article')
      expect(Array.wrap(crossref_xml.dig('contributors', 'person_name')).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig('contributors',
                                         'person_name')).first).to eq('contributor_role' => 'author', 'given_name' => 'David J',
                                                                      'sequence' => 'first', 'surname' => 'Mossman')
      expect(crossref_xml.dig('titles',
                              'title')).to eq('An Overview of the Geology of Canadian Gold Occurrences')
    end

    it 'schema.org from front matter' do
      input = 'https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/r9nqx6h-97aq74v-ag7bw')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health')
      expect(subject.type).to eq('Article')
      expect(subject.titles).to eq([{ 'title' => 'Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health' }])
      expect(subject.creators).to eq([{ 'familyName' => 'Fenner',
                                        'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-1419-2405',
                                        'type' => 'Person' }])
      expect(subject.subjects).to eq([{ 'subject' => 'news' }])
      expect(subject.language).to eq('en')
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(crossref_xml.dig('titles',
                              'title')).to eq('Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health')
    end

    it 'another schema.org from front-matter' do
      input = 'https://blog.front-matter.io/posts/dryad-interview-jen-gibson'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/rceh7pn-tzg61kj-7zv63')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/dryad-interview-jen-gibson')
      expect(subject.type).to eq('Article')
      expect(subject.titles).to eq([{ 'title' => 'Dryad: Interview with Jen Gibson' }])
      expect(subject.creators).to eq([{ 'familyName' => 'Fenner',
                                        'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-1419-2405',
                                        'type' => 'Person' }])
      expect(subject.subjects).to eq([{ 'subject' => 'interview' }])
      expect(subject.container).to eq('identifier' => '2749-9952', 'identifierType' => 'ISSN',
                                      'title' => 'Front Matter', 'type' => 'Periodical')
      expect(subject.language).to eq('en')
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(crossref_xml.dig('titles', 'title')).to eq('Dryad: Interview with Jen Gibson')
    end

    it 'embedded schema.org from front matter' do
      input = "#{fixture_path}schema_org_front-matter.json"
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/r9nqx6h-97aq74v-ag7bw')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/editorial-by-more-than-200-call-for-emergency-action-to-limit-global-temperature-increases-restore-biodiversity-and-protect-health')
      expect(subject.type).to eq('Article')
      expect(subject.container).to eq('identifier' => '2749-9952', 'identifierType' => 'ISSN',
                                      'title' => 'Front Matter', 'type' => 'Periodical')
      expect(subject.titles).to eq([{ 'title' => 'Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health' }])
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(Array.wrap(crossref_xml.dig('contributors', 'person_name')).length).to eq(1)
      expect(Array.wrap(crossref_xml.dig('contributors',
                                         'person_name')).first).to eq('ORCID' => 'https://orcid.org/0000-0003-1419-2405',
                                                                      'contributor_role' => 'author', 'given_name' => 'Martin', 'sequence' => 'first', 'surname' => 'Fenner')
      expect(crossref_xml.dig('titles',
                              'title')).to eq('Editorial by more than 200 health journals: Call for emergency action to limit global temperature increases, restore biodiversity, and protect health')
    end

    it 'schema.org from another science blog' do
      input = 'https://donnywinston.com/posts/implementing-the-fair-principles-through-fair-enabling-artifacts-and-services/'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.57099/11h5yt3819')
      expect(subject.url).to eq('https://donnywinston.com/posts/implementing-the-fair-principles-through-fair-enabling-artifacts-and-services')
      expect(subject.type).to eq('Article')
      expect(subject.titles).to eq([{ 'title' => 'Implementing the FAIR Principles Through FAIR-Enabling Artifacts and Services' }])
      expect(subject.creators).to eq([{ 'familyName' => 'Winston',
                                        'givenName' => 'Donny',
                                        'id' => 'https://orcid.org/0000-0002-8424-0604',
                                        'type' => 'Person' }])
      expect(subject.subjects).to eq([])
      expect(subject.container).to eq('identifier' => 'https://www.polyneme.xyz',
                                      'identifierType' => 'URL', 'type' => 'Periodical')
      expect(subject.language).to eq('en-US')
      expect(subject.date).to eq('created' => '2022-10-21',
                                 'published' => '2022-10-21',
                                 'updated' => '2022-10-21')
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(crossref_xml.dig('titles',
                              'title')).to eq('Implementing the FAIR Principles Through FAIR-Enabling Artifacts and Services')
    end

    it 'schema.org from upstream blog' do
      input = 'https://upstream.force11.org/deep-dive-into-ethics-of-contributor-roles/'
      subject = described_class.new(input: input, from: 'schema_org')

      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.54900/rf84ag3-98f00rt-0phta')
      expect(subject.url).to eq('https://upstream.force11.org/deep-dive-into-ethics-of-contributor-roles')
      expect(subject.type).to eq('Article')
      expect(subject.titles).to eq([{ 'title' => 'Deep dive into ethics of Contributor Roles: report of a FORCE11 workshop' }])
      expect(subject.creators.length).to eq(4)
      expect(subject.creators.first).to eq('familyName' => 'Hosseini',
                                           'givenName' => 'Mohammad',
                                           'type' => 'Person')
      expect(subject.subjects).to eq([{ 'subject' => 'news' }])
      expect(subject.language).to eq('en')
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      crossref_xml = Hash.from_xml(subject.crossref_xml).dig('doi_batch', 'body', 'posted_content')
      expect(Array.wrap(crossref_xml.dig('contributors', 'person_name')).length).to eq(4)
      expect(Array.wrap(crossref_xml.dig('contributors',
                                         'person_name')).first).to eq('contributor_role' => 'author', 'given_name' => 'Mohammad',
                                                                      'sequence' => 'first', 'surname' => 'Hosseini')
      expect(crossref_xml.dig('titles',
                              'title')).to eq('Deep dive into ethics of Contributor Roles: report of a FORCE11 workshop')
    end
  end
end