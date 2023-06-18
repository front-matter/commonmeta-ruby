# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  context 'write metadata as ris' do
    it 'journal article' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref_xml')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(ris[2]).to eq('T2  - eLife')
      expect(ris[3]).to eq('AU  - Sankar, Martial')
      expect(ris[8]).to eq('DO  - 10.7554/elife.01567')
      expect(ris[9]).to eq('UR  - https://elifesciences.org/articles/01567')
      expect(ris[10]).to start_with('AB  - Among various advantages')
      expect(ris[11]).to eq('PY  - 2014')
      expect(ris[12]).to eq('PB  - eLife Sciences Publications, Ltd')
      expect(ris[13]).to eq('VL  - 3')
      expect(ris[14]).to eq('SP  - e01567')
      expect(ris[15]).to eq('SN  - 2050-084X')
      expect(ris[16]).to eq('ER  - ')
    end

    it 'with pages' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input, from: 'crossref_xml')
      # expect(subject.valid?).to be true
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers')
      expect(ris[2]).to eq('T2  - Pulmonary Medicine')
      expect(ris[3]).to eq('AU  - Thanassi, Wendy')
      expect(ris[10]).to eq('DO  - 10.1155/2012/291294')
      expect(ris[11]).to eq('UR  - http://www.hindawi.com/journals/pm/2012/291294')
      expect(ris[12]).to start_with('AB  - . To find a statistically significant separation point for the QuantiFERON')
      expect(ris[13]).to eq('PY  - 2012')
      expect(ris[14]).to eq('PB  - Hindawi Limited')
      expect(ris[15]).to eq('VL  - 2012')
      expect(ris[16]).to eq('SP  - 1')
      expect(ris[17]).to eq('EP  - 7')
      expect(ris[18]).to eq('SN  - 2090-1844')
      expect(ris[19]).to eq('ER  - ')
    end

    it 'alternate name' do
      input = 'https://doi.org/10.3205/ZMA001102'
      subject = described_class.new(input: input, from: 'datacite')
      # expect(subject.valid?).to be true
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - GEN')
      expect(ris[1]).to eq('T1  - Visions and reality: the idea of competence-oriented assessment for German medical students is not yet realised in licensing examinations')
      expect(ris[2]).to eq('T2  - GMS Journal for Medical Education; 34(2):Doc25')
      expect(ris[3]).to eq('AU  - Huber-Lang, Markus')
      expect(ris[9]).to eq('DO  - 10.3205/zma001102')
      expect(ris[10]).to eq('UR  - http://www.egms.de/en/journals/zma/2017-34/zma001102.shtml')
      expect(ris[11]).to start_with('AB  - Objective: Competence orientation')
      expect(ris[12]).to eq('KW  - Medical competence')
      expect(ris[22]).to eq('PY  - 2017')
      expect(ris[23]).to eq('PB  - German Medical Science GMS Publishing House')
      expect(ris[24]).to eq('LA  - en')
      expect(ris[25]).to eq('SN  - 2366-5017')
      expect(ris[26]).to eq('ER  - ')
    end

    it 'Crossref DOI' do
      input = "#{fixture_path}crossref.bib"
      subject = described_class.new(input: input, from: 'bibtex')

      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth')
      expect(ris[2]).to eq('T2  - eLife')
      expect(ris[3]).to eq('AU  - Sankar, Martial')
      expect(ris[8]).to eq('DO  - 10.7554/elife.01567')
      expect(ris[9]).to eq('UR  - http://elifesciences.org/lookup/doi/10.7554/eLife.01567')
      expect(ris[10]).to eq('AB  - Among various advantages, their small size makes model organisms preferred subjects of investigation. Yet, even in model systems detailed analysis of numerous developmental processes at cellular level is severely hampered by their scale.')
      expect(ris[11]).to eq('PY  - 2014')
      expect(ris[12]).to eq('PB  - {eLife} Sciences Organisation, Ltd.')
      expect(ris[13]).to eq('VL  - 3')
      expect(ris[14]).to eq('SN  - 2050-084X')
      expect(ris[15]).to eq('ER  - ')
    end

    it 'BlogPosting' do
      input = 'https://doi.org/10.5438/4K3M-NYVG'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Eating your own Dog Food')
      expect(ris[2]).to eq('AU  - Fenner, Martin')
      expect(ris[3]).to eq('DO  - 10.5438/4k3m-nyvg')
      expect(ris[4]).to eq('UR  - https://blog.datacite.org/eating-your-own-dog-food/')
      expect(ris[5]).to eq('AB  - Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for...')
      expect(ris[6]).to eq('KW  - Datacite')
      expect(ris[9]).to eq('KW  - Fos: computer and information sciences')
      expect(ris[10]).to eq('PY  - 2016')
      expect(ris[11]).to eq('PB  - DataCite')
      expect(ris[12]).to eq('LA  - en')
      expect(ris[13]).to eq('SN  - 10.5438/0000-00ss')
      expect(ris[14]).to eq('ER  - ')
    end

    it 'BlogPosting Citeproc JSON' do
      input = "#{fixture_path}citeproc.json"
      subject = described_class.new(input: input, from: 'csl')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Eating your own Dog Food')
      expect(ris[2]).to eq('T2  - DataCite Blog')
      expect(ris[3]).to eq('AU  - Fenner, Martin')
      expect(ris[4]).to eq('DO  - 10.5438/4k3m-nyvg')
      expect(ris[5]).to eq('UR  - https://blog.datacite.org/eating-your-own-dog-food')
      expect(ris[6]).to eq('AB  - Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for...')
      expect(ris[7]).to eq('KW  - Phylogeny')
      expect(ris[14]).to eq('PY  - 2016')
      expect(ris[15]).to eq('PB  - DataCite')
      expect(ris[16]).to eq('ER  - ')
    end

    it 'BlogPosting DataCite JSON' do
      input = "#{fixture_path}datacite.json"
      subject = described_class.new(input: input, from: 'datacite')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Eating your own Dog Food')
      expect(ris[2]).to eq('AU  - Fenner, Martin')
      expect(ris[3]).to eq('DO  - 10.5438/4k3m-nyvg')
      expect(ris[4]).to eq('AB  - Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for...')
      expect(ris[5]).to eq('KW  - Datacite')
      expect(ris[8]).to eq('PY  - 2016')
      expect(ris[9]).to eq('PB  - DataCite')
      expect(ris[10]).to eq('ER  - ')
    end

    it 'BlogPosting schema.org' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food/'
      subject = described_class.new(input: input, from: 'schema_org')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - JOUR')
      expect(ris[1]).to eq('T1  - Eating your own Dog Food')
      expect(ris[2]).to eq('T2  - Front Matter')
      expect(ris[3]).to eq('AU  - Fenner, Martin')
      expect(ris[4]).to eq('DO  - 10.53731/r79vxn1-97aq74v-ag58n')
      expect(ris[5]).to eq('UR  - https://blog.front-matter.io/posts/eating-your-own-dog-food')
      expect(ris[6]).to eq('AB  - Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for the scholarly outputs we produce. For the most part this is not research data, but rather technical documents such as the DataCite Schema and its documentation (2016). These outputs also include the posts on this blog, where we discuss topics relev')
      expect(ris[7]).to eq('KW  - Feature')
      expect(ris[8]).to eq('PY  - 2016')
      expect(ris[9]).to eq('PB  - Front Matter')
      expect(ris[10]).to eq('LA  - en')
      expect(ris[11]).to eq('SN  - https://blog.front-matter.io/')
      expect(ris[12]).to eq('ER  - ')
    end

    it 'Dataset' do
      input = '10.5061/DRYAD.8515'
      subject = described_class.new(input: input, from: 'datacite')
      expect(subject.valid?).to be true
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - DATA')
      expect(ris[1]).to eq('T1  - Data from: A new malaria agent in African hominids.')
      expect(ris[2]).to eq('AU  - Ollomo, Benjamin')
      expect(ris[10]).to eq('DO  - 10.5061/dryad.8515')
      expect(ris[11]).to eq('UR  - https://datadryad.org/stash/dataset/doi:10.5061/dryad.8515')
      expect(ris[13]).to eq('KW  - Plasmodium')
      expect(ris[18]).to eq('PB  - Dryad')
      expect(ris[19]).to eq('LA  - en')
      expect(ris[20]).to eq('ER  - ')
    end

    it 'maremma' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - COMP')
      expect(ris[1]).to eq('T1  - Maremma: a Ruby library for simplified network calls')
      expect(ris[2]).to eq('AU  - Fenner, Martin')
      expect(ris[3]).to eq('DO  - 10.5438/qeg0-3gm3')
      expect(ris[4]).to eq('UR  - https://github.com/datacite/maremma')
      expect(ris[5]).to eq('AB  - Ruby utility library for network requests. Based on Faraday and Excon, provides a wrapper for XML/JSON parsing and error handling. All successful responses are returned as hash with key data, all errors in a JSONAPI-friendly hash with key errors.')
      expect(ris[6]).to eq('KW  - Faraday')
      expect(ris[9]).to eq('PY  - 2017')
      expect(ris[10]).to eq('PB  - DataCite')
      expect(ris[11]).to eq('ER  - ')
    end

    it 'keywords with subject scheme' do
      input = 'https://doi.org/10.1594/pangaea.721193'
      subject = described_class.new(input: input, from: 'datacite')
      ris = subject.ris.split("\r\n")
      expect(ris[0]).to eq('TY  - DATA')
      expect(ris[1]).to eq('T1  - Seawater carbonate chemistry and processes during experiments with Crassostrea gigas, 2007')
      expect(ris[2]).to eq('AU  - Kurihara, Haruko')
      expect(ris[5]).to eq('DO  - 10.1594/pangaea.721193')
      expect(ris[6]).to eq('UR  - https://doi.pangaea.de/10.1594/PANGAEA.721193')
      expect(ris[8]).to eq('KW  - Animalia')
      expect(ris[9]).to eq('KW  - Bottles or small containers/aquaria (&lt;20 l)')
      expect(ris[51]).to eq('PY  - 2007')
      expect(ris[52]).to eq('PB  - PANGAEA')
      expect(ris[53]).to eq('LA  - en')
      expect(ris[54]).to eq('ER  - ')
    end
  end
end
