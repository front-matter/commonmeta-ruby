# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context 'write metadata as jats xml' do
    it 'with data citation' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(jats['source']).to eq('eLife')
      expect(jats.dig('person_group', 'name').length).to eq(5)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Sankar', 'given_names' => 'Martial')
      expect(jats['year']).to eq('iso_8601_date' => '2014-02-11', '__content__' => '2014')
      expect(jats['month']).to eq('02')
      expect(jats['day']).to eq('11')
    end

    it 'with ORCID ID' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers')
      expect(jats['source']).to eq('Pulmonary Medicine')
      expect(jats.dig('person_group', 'name').length).to eq(7)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Thanassi', 'given_names' => 'Wendy')
      expect(jats['year']).to eq('iso_8601_date' => '2012', '__content__' => '2012')
    end

    it 'with editor' do
      input = 'https://doi.org/10.1371/journal.pone.0000030'
      subject = described_class.new(input: input, from: 'crossref')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Triose Phosphate Isomerase Deficiency Is Caused by Altered Dimerization–Not Catalytic Inactivity–of the Mutant Enzymes')
      expect(jats['source']).to eq('PLoS ONE')
      expect(jats.dig('person_group', 0, 'name').length).to eq(5)
      expect(jats.dig('person_group', 0,
                      'name').first).to eq('surname' => 'Ralser', 'given_names' => 'Markus')
      expect(jats.dig('person_group', 1,
                      'name')).to eq('surname' => 'Janbon', 'given_names' => 'Guilhem')
      expect(jats['year']).to eq('iso_8601_date' => '2006-12-20', '__content__' => '2006')
      expect(jats['month']).to eq('12')
      expect(jats['day']).to eq('20')
      expect(jats['fpage']).to eq('e30')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi',
                                   '__content__' => '10.1371/journal.pone.0000030')
    end

    it 'book chapter' do
      input = 'https://doi.org/10.5005/jp/books/12414_3'
      subject = described_class.new(input: input, from: 'crossref')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('chapter')
      expect(jats['chapter_title']).to eq('Physical Examinations')
      expect(jats['source']).to eq('Jaypee Brothers Medical Publishers (P) Ltd.')
      expect(jats.dig('person_group', 'name')).to eq('surname' => 'Saha', 'given_names' => 'Ashis')
      expect(jats['year']).to eq('iso_8601_date' => '2015', '__content__' => '2015')
      expect(jats['fpage']).to eq('27')
      expect(jats['lpage']).to eq('27')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi',
                                   '__content__' => '10.5005/jp/books/12414_3')
    end

    it 'Crossref DOI' do
      input = "#{fixture_path}crossref.bib"
      subject = described_class.new(input: input, from: 'bibtex')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(jats['source']).to eq('eLife')
      expect(jats.dig('person_group', 'name').length).to eq(5)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Sankar', 'given_names' => 'Martial')
      expect(jats['year']).to eq('iso_8601_date' => '2014', '__content__' => '2014')
      expect(jats['month'].nil?).to be(true)
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.7554/elife.01567')
    end

    it 'BlogPosting Citeproc JSON' do
      input = "#{fixture_path}citeproc.json"
      subject = described_class.new(input: input, from: 'csl')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type'].nil?).to be(true)
      expect(jats['source']).to eq('Eating your own Dog Food')
      expect(jats['publisher_name']).to eq('DataCite')
      expect(jats.dig('person_group',
                      'name')).to eq('surname' => 'Fenner', 'given_names' => 'Martin')
      expect(jats['year']).to eq('iso_8601_date' => '2016-12-20', '__content__' => '2016')
      expect(jats['month']).to eq('12')
      expect(jats['day']).to eq('20')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.5438/4k3m-nyvg')
    end

    it 'rdataone' do
      input = "#{fixture_path}codemeta.json"
      subject = described_class.new(input: input, from: 'codemeta')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('software')
      expect(jats['source']).to eq('R Interface to the DataONE REST API')
      expect(jats['publisher_name']).to eq('https://cran.r-project.org')
      expect(jats.dig('person_group', 'name').length).to eq(3)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Jones', 'given_names' => 'Matt')
      expect(jats['year']).to eq('iso_8601_date' => '2016-05-27', '__content__' => '2016')
      expect(jats['month']).to eq('05')
      expect(jats['day']).to eq('27')
      expect(jats['version']).to eq('2.0.0')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.5063/f1m61h5x')
    end

    it 'maremma' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('software')
      expect(jats['source']).to eq('Maremma: a Ruby library for simplified network calls')
      expect(jats['publisher_name']).to eq('DataCite')
      expect(jats.dig('person_group',
                      'name')).to eq('surname' => 'Fenner', 'given_names' => 'Martin')
      expect(jats['year']).to eq('iso_8601_date' => '2017-02-24', '__content__' => '2017')
      expect(jats['month']).to eq('02')
      expect(jats['day']).to eq('24')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.5438/qeg0-3gm3')
    end

    it 'Text pass-thru' do
      input = 'https://doi.org/10.23640/07243.5153971'
      subject = described_class.new(input: input, from: 'datacite')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Recommendation of: ORCID Works Metadata Working Group')
      expect(jats['source']).to eq('Figshare')
      expect(jats.dig('person_group', 'name').length).to eq(20)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Paglione', 'given_names' => 'Laura')
      expect(jats['year']).to eq('iso_8601_date' => '2017', '__content__' => '2017')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi',
                                   '__content__' => '10.23640/07243.5153971')
    end

    it 'Dataset in schema 4.0' do
      input = 'https://doi.org/10.5061/DRYAD.8515'
      subject = described_class.new(input: input, from: 'datacite', regenerate: true)
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('data')
      expect(jats['data_title']).to eq('Data from: A new malaria agent in African hominids.')
      expect(jats['source']).to eq('Dryad')
      expect(jats.dig('person_group', 'name').length).to eq(8)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Ollomo', 'given_names' => 'Benjamin')
      expect(jats['year']).to eq('iso_8601_date' => '2011', '__content__' => '2011')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.5061/dryad.8515')
    end

    it 'from schema_org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food/'
      subject = described_class.new(input: input, from: 'schema_org')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Eating your own Dog Food')
      expect(jats['source']).to eq('Front Matter')
      expect(jats['publisher_name']).to eq('Front Matter')
      expect(jats.dig('person_group',
                      'name')).to eq('surname' => 'Fenner', 'given_names' => 'Martin')
      expect(jats['year']).to eq('iso_8601_date' => '2016-12-20T00:00:00Z', '__content__' => '2016')
      expect(jats['month']).to eq('12')
      expect(jats['day']).to eq('20')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi',
                                   '__content__' => '10.53731/r79vxn1-97aq74v-ag58n')
    end

    it 'interactive resource without dates' do
      input = 'https://doi.org/10.34747/g6yb-3412'
      subject = described_class.new(input: input, from: 'datacite')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type'].nil?).to be(true)
      expect(jats['source']).to eq('Exploring the "Many analysts, one dataset" project from COS')
      expect(jats['publisher_name']).to eq('Gigantum, Inc.')
      expect(jats.dig('person_group', 'name')).to eq('given_names' => 'Dav', 'surname' => 'Clark')
      expect(jats['year']).to eq('__content__' => '2019', 'iso_8601_date' => '2019')
      expect(jats['month'].nil?).to be(true)
      expect(jats['day'].nil?).to be(true)
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.34747/g6yb-3412')
    end
  end

  context 'change metadata as datacite xml' do
    it 'with data citation' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      jats = XmlHasher.parse(subject.jats).fetch('element_citation', {})
      expect(jats['publication_type']).to eq('journal')
      expect(jats['article_title']).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(jats['source']).to eq('eLife')
      expect(jats.dig('person_group', 'name').length).to eq(5)
      expect(jats.dig('person_group',
                      'name').first).to eq('surname' => 'Sankar', 'given_names' => 'Martial')
      expect(jats['year']).to eq('iso_8601_date' => '2014-02-11', '__content__' => '2014')
      expect(jats['month']).to eq('02')
      expect(jats['day']).to eq('11')
      expect(jats['pub_id']).to eq('pub_id_type' => 'doi', '__content__' => '10.7554/elife.01567')
    end
  end
end
