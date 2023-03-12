# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context 'write metadata as bibtex' do
    it 'with data citation' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.7554/elife.01567')
      expect(bibtex[:doi]).to eq('10.7554/elife.01567')
      expect(bibtex[:url]).to eq('https://elifesciences.org/articles/01567')
      expect(bibtex[:title]).to eq('Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(bibtex[:author]).to eq('Sankar, Martial and Nieminen, Kaisa and Ragni, Laura and Xenarios, Ioannis and Hardtke, Christian S')
      expect(bibtex[:journal]).to eq('eLife')
      expect(bibtex[:year]).to eq('2014')
      expect(bibtex[:copyright]).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'with schema_3' do
      input = "#{fixture_path}datacite_schema_3.xml"
      json = described_class.new(input: input, from: 'datacite_xml')
      subject = described_class.new(input: json.meta.to_json, from: 'datacite')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5061/dryad.8515')
      expect(bibtex[:doi]).to eq('10.5061/dryad.8515')
      expect(bibtex[:year]).to eq('2011')
    end

    it 'with pages' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.1155/2012/291294')
      expect(bibtex[:doi]).to eq('10.1155/2012/291294')
      expect(bibtex[:url]).to eq('http://www.hindawi.com/journals/pm/2012/291294')
      expect(bibtex[:title]).to eq('Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers')
      expect(bibtex[:author]).to eq('Thanassi, Wendy and Noda, Art and Hernandez, Beatriz and Newell, Jeffery and Terpeluk, Paul and Marder, David and Yesavage, Jerome A.')
      expect(bibtex[:journal]).to eq('Pulmonary Medicine')
      expect(bibtex[:pages]).to eq('1-7')
      expect(bibtex[:year]).to eq('2012')
      expect(bibtex[:copyright]).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'text' do
      input = '10.3204/desy-2014-01645'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('phdthesis')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.3204/desy-2014-01645')
      expect(bibtex[:doi]).to eq('10.3204/desy-2014-01645')
      expect(bibtex[:title]).to eq('Dynamics of colloids in molecular glass forming liquids studied via X-ray photon correlation spectroscopy')
      expect(bibtex[:pages]).to eq('2014')
      expect(bibtex[:year]).to eq('2014')
    end

    it 'climate data' do
      input = 'https://doi.org/10.5067/altcy-tj122'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5067/altcy-tj122')
      expect(bibtex[:doi]).to eq('10.5067/altcy-tj122')
      expect(bibtex[:title]).to eq('Integrated Multi-Mission Ocean Altimeter Data for Climate Research Version 2')
      expect(bibtex[:pages].nil?).to be(true)
    end

    it 'maremma' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(bibtex[:doi]).to eq('10.5438/qeg0-3gm3')
      expect(bibtex[:url]).to eq('https://github.com/datacite/maremma')
      expect(bibtex[:title]).to eq('Maremma: a Ruby library for simplified network calls')
      expect(bibtex[:author]).to eq('Fenner, Martin')
      expect(bibtex[:publisher]).to eq('DataCite')
      expect(bibtex[:keywords]).to eq('faraday, excon, net/http')
      expect(bibtex[:year]).to eq('2017')
      expect(bibtex[:copyright]).to eq('MIT License')
    end

    it 'BlogPosting from string' do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(bibtex[:doi]).to eq('10.5438/4k3m-nyvg')
      expect(bibtex[:title]).to eq('Eating your own Dog Food')
      expect(bibtex[:author]).to eq('Fenner, Martin')
      expect(bibtex[:publisher]).to eq('DataCite')
      expect(bibtex[:year]).to eq('2016')
    end

    it 'BlogPosting' do
      input = 'https://doi.org/10.5438/4K3M-NYVG'
      subject = described_class.new(input: input, from: 'datacite')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(bibtex[:doi]).to eq('10.5438/4k3m-nyvg')
      expect(bibtex[:title]).to eq('Eating your own Dog Food')
      expect(bibtex[:author]).to eq('Fenner, Martin')
      expect(bibtex[:publisher]).to eq('DataCite')
      expect(bibtex[:year]).to eq('2016')
    end

    it 'Dataset' do
      input = 'https://doi.org/10.5061/dryad.8515'
      subject = described_class.new(input: input, from: 'datacite')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.5061/dryad.8515')
      expect(bibtex[:doi]).to eq('10.5061/dryad.8515')
      expect(bibtex[:title]).to eq('Data from: A new malaria agent in African hominids.')
      expect(bibtex[:author]).to eq('Ollomo, Benjamin and Durand, Patrick and Prugnolle, Franck and Douzery, Emmanuel J. P. and Arnathau, C??line and Nkoghe, Dieudonn?? and Leroy, Eric and Renaud, Fran??ois')
      expect(bibtex[:publisher]).to eq('Dryad')
      expect(bibtex[:year]).to eq('2011')
      expect(bibtex[:copyright]).to eq('Creative Commons Zero v1.0 Universal')
    end

    it 'from schema_org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food/'
      subject = described_class.new(input: input, from: 'schema_org')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.53731/r79vxn1-97aq74v-ag58n')
      expect(bibtex[:doi]).to eq('10.53731/r79vxn1-97aq74v-ag58n')
      expect(bibtex[:title]).to eq('Eating your own Dog Food')
      expect(bibtex[:author]).to eq('Fenner, Martin')
      expect(bibtex[:publisher]).to eq('Front Matter')
      expect(bibtex[:keywords]).to eq('feature')
      expect(bibtex[:year]).to eq('2016')
    end

    it 'authors with affiliations' do
      input = '10.16910/jemr.9.1.2'
      subject = described_class.new(input: input, from: 'crossref')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('article')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.16910/jemr.9.1.2')
      expect(bibtex[:doi]).to eq('10.16910/jemr.9.1.2')
      expect(bibtex[:title]).to eq('Eye tracking scanpath analysis techniques on web pages: A survey, evaluation and comparison')
      expect(bibtex[:author]).to eq('Eraslan, Sukru and Yesilada, Yeliz and Harper, Simon')
      expect(bibtex[:publisher]).to eq('University of Bern')
      expect(bibtex[:year]).to eq('2015')
    end

    it 'keywords subject scheme' do
      input = 'https://doi.org/10.1594/pangaea.721193'
      subject = described_class.new(input: input, from: 'datacite')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.1594/pangaea.721193')
      expect(bibtex[:doi]).to eq('10.1594/pangaea.721193')
      expect(bibtex[:keywords]).to start_with('Animalia, Bottles or small containers/Aquaria (&lt;20 L)')
      expect(bibtex[:year]).to eq('2007')
      expect(bibtex[:copyright]).to eq('Creative Commons Attribution 3.0 Unported')
    end

    it 'author is organization' do
      input = "#{fixture_path}gtex.xml"
      subject = described_class.new(input: input, from: 'datacite')
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.25491/9hx8-ke93')
      expect(bibtex[:author]).to eq('{The GTEx Consortium}')
    end

    it 'dataset neurophysiology' do
      input = "#{fixture_path}datacite-schema-2.2.xml"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      bibtex = BibTeX.parse(subject.bibtex).to_a(quotes: '').first
      expect(bibtex[:bibtex_type].to_s).to eq('misc')
      expect(bibtex[:bibtex_key]).to eq('https://doi.org/10.6080/k0f769gp')
      expect(bibtex[:doi]).to eq('10.6080/k0f769gp')
      expect(bibtex[:title]).to eq('Single-unit recordings from two auditory areas in male zebra finches')
      expect(bibtex[:author]).to eq('{Theunissen, Frederic E.} and {Hauber, ME} and {Woolley, Sarah M. N.} and Gill, Patrick and {Shaevitz, SS} and {Amin, Noopur} and {Hsu, A} and {Singh, NC} and {Grace, GA} and Fremouw, Thane and {Zhang, Junli} and {Cassey, P} and {Doupe, AJ} and {David, SV} and {Vinje, WE}')
      expect(bibtex[:publisher]).to eq('CRCNS.org')
      expect(bibtex[:keywords]).to eq('neuroscience, electrophysiology, auditory area, avian (zebra finch)')
      expect(bibtex[:year]).to eq('2009')
    end
  end
end
