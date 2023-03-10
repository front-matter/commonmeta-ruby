# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context 'write metadata as csl' do
    it 'Dataset' do
      input = 'https://doi.org/10.5061/DRYAD.8515'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('dataset')
      expect(json['id']).to eq('https://doi.org/10.5061/dryad.8515')
      expect(json['DOI']).to eq('10.5061/dryad.8515')
      expect(json['title']).to eq('Data from: A new malaria agent in African hominids.')
      expect(json['author']).to eq([{ 'family' => 'Ollomo', 'given' => 'Benjamin' },
                                    { 'family' => 'Durand', 'given' => 'Patrick' },
                                    { 'family' => 'Prugnolle', 'given' => 'Franck' },
                                    { "literal"=>"Douzery, Emmanuel J. P."},
                                    { 'family' => 'Arnathau', 'given' => 'Céline' },
                                    { 'family' => 'Nkoghe', 'given' => 'Dieudonné' },
                                    { 'family' => 'Leroy', 'given' => 'Eric' },
                                    { 'family' => 'Renaud', 'given' => 'François' }])
      expect(json['publisher']).to eq('Dryad')
      expect(json['issued']).to eq('date-parts' => [[2011]])
      expect(json['submitted'].nil?).to be(true)
      expect(json['copyright']).to eq('Creative Commons Zero v1.0 Universal')
    end

    it 'BlogPosting' do
      input = 'https://doi.org/10.5438/4K3M-NYVG'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(json['DOI']).to eq('10.5438/4k3m-nyvg')
      expect(json['title']).to eq('Eating your own Dog Food')
      expect(json['author']).to eq([{ 'family' => 'Fenner', 'given' => 'Martin' }])
      expect(json['publisher']).to eq('DataCite')
      expect(json['issued']).to eq('date-parts' => [[2016, 12, 20]])
    end

    it 'BlogPosting DataCite JSON' do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(json['DOI']).to eq('10.5438/4k3m-nyvg')
      expect(json['title']).to eq('Eating your own Dog Food')
      expect(json['author']).to eq([{ 'family' => 'Fenner', 'given' => 'Martin' }])
      expect(json['publisher']).to eq('DataCite')
      expect(json['issued']).to eq('date-parts' => [[2016, 12, 20]])
    end

    it 'BlogPosting schema.org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food/'
      subject = described_class.new(input: input, from: 'schema_org')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-newspaper')
      expect(json['id']).to eq('https://doi.org/10.53731/r79vxn1-97aq74v-ag58n')
      expect(json['DOI']).to eq('10.53731/r79vxn1-97aq74v-ag58n')
      expect(json['title']).to eq('Eating your own Dog Food')
      expect(json['author']).to eq([{ 'family' => 'Fenner', 'given' => 'Martin' }])
      expect(json['publisher']).to eq('Front Matter')
      expect(json['issued']).to eq('date-parts' => [[2016, 12, 20]])
    end

    it 'Another dataset' do
      input = '10.26301/qdpd-2250'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('dataset')
      expect(json['id']).to eq('https://doi.org/10.26301/qdpd-2250')
      expect(json['DOI']).to eq('10.26301/qdpd-2250')
      expect(json['title']).to eq('USS Pampanito Submarine')
      expect(json['author']).to eq([{ 'literal' => 'USS Pampanito' },
                                    { 'literal' => 'Autodesk' },
                                    { 'literal' => 'Topcon' },
                                    { 'literal' => '3D Robotics' },
                                    { 'literal' => 'CyArk' },
                                    { 'literal' => 'San Francisco Maritime National Park Association' }])
      expect(json['publisher']).to eq('OpenHeritage3D')
      expect(json['issued']).to eq('date-parts' => [[2020]])
    end

    it 'journal article' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.7554/elife.01567')
      expect(json['DOI']).to eq('10.7554/elife.01567')
      expect(json['title']).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(json['author']).to eq([{ 'family' => 'Sankar', 'given' => 'Martial' },
                                    { 'family' => 'Nieminen', 'given' => 'Kaisa' },
                                    { 'family' => 'Ragni', 'given' => 'Laura' },
                                    { 'family' => 'Xenarios', 'given' => 'Ioannis' },
                                    { 'family' => 'Hardtke', 'given' => 'Christian S' }])
      expect(json['container-title']).to eq('eLife')
      expect(json['volume']).to eq('3')
      expect(json['issued']).to eq('date-parts' => [[2014, 2, 11]])
      expect(json['copyright']).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'software' do
      input = 'https://doi.org/10.6084/m9.figshare.4906367.v1'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article')
      expect(json['DOI']).to eq('10.6084/m9.figshare.4906367.v1')
      expect(json['title']).to eq('Scimag catalogue of LibGen as of January 1st, 2014')
      expect(json['copyright']).to eq('Creative Commons Zero v1.0 Universal')
    end

    it 'software w/version' do
      input = 'https://doi.org/10.5281/zenodo.2598836'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('book')
      expect(json['DOI']).to eq('10.5281/zenodo.2598836')
      expect(json['version']).to eq('1.0.0')
      expect(json['copyright']).to eq('Open Access')
    end

    it 'software w/version from datacite' do
      input = "#{fixture_path}datacite_software_version.json"
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('book')
      expect(json['DOI']).to eq('10.5281/ZENODO.2598836')
      expect(json['version']).to eq('1.0.0')
      expect(json['copyright']).to eq('Open Access')
    end

    it 'multiple abstracts' do
      input = 'https://doi.org/10.12763/ona1045'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['DOI']).to eq('10.12763/ona1045')
      expect(json['abstract']).to eq("Le code est accompagné de commentaires de F. A. Vogel, qui signe l'épitre dédicatoire")
    end

    it 'with pages' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.1155/2012/291294')
      expect(json['DOI']).to eq('10.1155/2012/291294')
      expect(json['title']).to eq('Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers')
      expect(json['author']).to eq([{ 'family' => 'Thanassi', 'given' => 'Wendy' },
                                    { 'family' => 'Noda', 'given' => 'Art' },
                                    { 'family' => 'Hernandez', 'given' => 'Beatriz' },
                                    { 'family' => 'Newell', 'given' => 'Jeffery' },
                                    { 'family' => 'Terpeluk', 'given' => 'Paul' },
                                    { 'family' => 'Marder', 'given' => 'David' },
                                    { 'family' => 'Yesavage', 'given' => 'Jerome A.' }])
      expect(json['container-title']).to eq('Pulmonary Medicine')
      expect(json['volume']).to eq('2012')
      expect(json['page']).to eq('1-7')
      expect(json['issued']).to eq('date-parts' => [[2012]])
      expect(json['copyright']).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'with only first page' do
      input = 'https://doi.org/10.1371/journal.pone.0214986'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.1371/journal.pone.0214986')
      expect(json['DOI']).to eq('10.1371/journal.pone.0214986')
      expect(json['title']).to eq('River metrics by the public, for the public')
      expect(json['author']).to eq([{ 'family' => 'Weber', 'given' => 'Matthew A.' },
                                    { 'family' => 'Ringold', 'given' => 'Paul L.' }])
      expect(json['container-title']).to eq('PLOS ONE')
      expect(json['volume']).to eq('14')
      expect(json['page']).to eq('e0214986')
      expect(json['issued']).to eq('date-parts' => [[2019, 5, 8]])
      expect(json['copyright']).to eq('Creative Commons Zero v1.0 Universal')
    end

    it 'missing creator' do
      input = 'https://doi.org/10.3390/publications6020015'
      subject = described_class.new(input: input, from: 'crossref')
      expect(subject.valid?).to be true
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.3390/publications6020015')
      expect(json['DOI']).to eq('10.3390/publications6020015')
      expect(json['title']).to eq('Converting the Literature of a Scientific Field to Open Access through Global Collaboration: The Experience of SCOAP3 in Particle Physics')
      expect(json['author']).to eq([{ 'family' => 'Kohls', 'given' => 'Alexander' },
                                    { 'family' => 'Mele', 'given' => 'Salvatore' }])
      expect(json['container-title']).to eq('Publications')
      expect(json['publisher']).to eq('MDPI AG')
      expect(json['page']).to eq('15')
      expect(json['issued']).to eq('date-parts' => [[2018, 4, 9]])
      expect(json['copyright']).to eq('Creative Commons Attribution 4.0 International')
    end

    it 'container title' do
      input = 'https://doi.org/10.6102/ZIS146'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.6102/zis146')
      expect(json['DOI']).to eq('10.6102/zis146')
      expect(json['title']).to eq('Deutsche Version der Positive and Negative Affect Schedule (PANAS)')
      expect(json['author']).to eq([{ 'family' => 'Janke', 'given' => 'S.' },
                                    { 'family' => 'Glöckner-Rist', 'given' => 'A.' }])
      expect(json['container-title']).to eq('Zusammenstellung sozialwissenschaftlicher Items und Skalen (ZIS)')
      expect(json['issued']).to eq('date-parts' => [[2012]])
    end

    it 'Crossref DOI' do
      input = "#{fixture_path}crossref.bib"
      subject = described_class.new(input: input, from: 'bibtex')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.7554/elife.01567')
      expect(json['DOI']).to eq('10.7554/elife.01567')
      expect(json['URL']).to eq('http://elifesciences.org/lookup/doi/10.7554/eLife.01567')
      expect(json['title']).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(json['author']).to eq([{ 'family' => 'Sankar', 'given' => 'Martial' },
                                    { 'family' => 'Nieminen', 'given' => 'Kaisa' },
                                    { 'family' => 'Ragni', 'given' => 'Laura' },
                                    { 'family' => 'Xenarios', 'given' => 'Ioannis' },
                                    { 'family' => 'Hardtke', 'given' => 'Christian S' }])
      expect(json['container-title']).to eq('eLife')
      expect(json['issued']).to eq('date-parts' => [[2014]])
    end

    it 'author is organization' do
      input = "#{fixture_path}gtex.xml"
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['id']).to eq('https://doi.org/10.25491/9hx8-ke93')
      expect(json['author']).to eq([{ 'literal' => 'The GTEx Consortium' }])
    end

    it 'maremma' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(json['DOI']).to eq('10.5438/qeg0-3gm3')
      expect(json['title']).to eq('Maremma: a Ruby library for simplified network calls')
      expect(json['author']).to eq([{ 'family' => 'Fenner', 'given' => 'Martin' }])
      expect(json['publisher']).to eq('DataCite')
      expect(json['issued']).to eq('date-parts' => [[2017, 2, 24]])
      expect(json['copyright']).to eq('MIT License')
    end

    it 'keywords subject scheme' do
      input = 'https://doi.org/10.1594/pangaea.721193'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('dataset')
      expect(json['id']).to eq('https://doi.org/10.1594/pangaea.721193')
      expect(json['DOI']).to eq('10.1594/pangaea.721193')
      expect(json['categories']).to include('animalia',
                                            'bottles or small containers/aquaria (&lt;20 l)')
      expect(json['copyright']).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'organization author' do
      input = 'https://doi.org/10.1186/s13742-015-0103-4'
      subject = described_class.new(input: input, from: 'crossref')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article-journal')
      expect(json['id']).to eq('https://doi.org/10.1186/s13742-015-0103-4')
      expect(json['DOI']).to eq('10.1186/s13742-015-0103-4')
      expect(json['author']).to eq([{ 'family' => 'Liu', 'given' => 'Siyang' },
                                    { 'family' => 'Huang', 'given' => 'Shujia' },
                                    { 'family' => 'Rao', 'given' => 'Junhua' },
                                    { 'family' => 'Ye', 'given' => 'Weijian' },
                                    { 'family' => 'Krogh', 'given' => 'Anders' },
                                    { 'family' => 'Wang', 'given' => 'Jun' },
                                    { 'literal' => 'The Genome Denmark Consortium' }])
      expect(json['container-title']).to eq('GigaScience')
    end

    it 'interactive resource without dates' do
      input = 'https://doi.org/10.34747/g6yb-3412'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.csl)
      expect(json['type']).to eq('article')
      expect(json['DOI']).to eq('10.34747/g6yb-3412')
      expect(json['issued']).to eq('date-parts' => [[2019]])
    end
  end
end
