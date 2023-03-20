# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { "#{fixture_path}crossref.json" }

  context 'get crossref raw' do
    it 'journal article' do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context 'get crossref metadata' do
    it 'DOI with data citation' do
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.url).to eq('https://elifesciences.org/articles/01567')
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq('type' => 'Person',
                                           'givenName' => 'Martial', 'familyName' => 'Sankar', 'affiliation' => [{ 'name' => 'Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland' }])
      expect(subject.license).to eq('id' => 'CC-BY-3.0',
                                    'url' => 'https://creativecommons.org/licenses/by/3.0/legalcode')
      expect(subject.titles).to eq([{ 'title' => 'Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth' }])
      expect(subject.date).to eq('published' => '2014-02-11', 'updated' => '2022-03-26')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/4374',
                                      'name' => 'eLife Sciences Publications, Ltd')
      expect(subject.container).to eq('identifier' => '2050-084X',
                                      'identifierType' => 'ISSN', 'title' => 'eLife', 'type' => 'Journal', 'volume' => '3')
      expect(subject.references.length).to eq(27)
      expect(subject.references.last).to eq('containerTitle' => 'Nature Cell Biology',
                                            'creator' => 'Yin',
                                            'doi' => 'https://doi.org/10.1038/ncb2764',
                                            'firstPage' => '860',
                                            'key' => 'bib27',
                                            'publicationYear' => '2013',
                                            'title' => 'A screen for morphological complexity identifies regulators of switch-like transitions between discrete cell shapes',
                                            'volume' => '15')
      expect(subject.funding_references).to eq([{ 'funderName' => 'SystemsX' },
                                                { 'funderName' => 'EMBO longterm post-doctoral fellowships' },
                                                { 'funderName' => 'Marie Heim-Voegtlin' },
                                                { 'funderIdentifier' => 'https://doi.org/10.13039/501100006390',
                                                  'funderIdentifierType' => 'Crossref Funder ID',
                                                  'funderName' => 'University of Lausanne' },
                                                { 'funderName' => 'SystemsX' },
                                                { 'funderIdentifier' => 'https://doi.org/10.13039/501100003043',
                                                  'funderIdentifierType' => 'Crossref Funder ID',
                                                  'funderName' => 'EMBO' },
                                                { 'funderIdentifier' => 'https://doi.org/10.13039/501100001711',
                                                  'funderIdentifierType' => 'Crossref Funder ID',
                                                  'funderName' => 'Swiss National Science Foundation' },
                                                { 'funderIdentifier' => 'https://doi.org/10.13039/501100006390',
                                                  'funderIdentifierType' => 'Crossref Funder ID',
                                                  'funderName' => 'University of Lausanne' }])
      expect(subject.provider).to eq('Crossref')
    end

    it 'journal article' do
      input = 'https://doi.org/10.1371/journal.pone.0000030'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1371/journal.pone.0000030')
      expect(subject.url).to eq('https://dx.plos.org/10.1371/journal.pone.0000030')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq('type' => 'Person',
                                           'givenName' => 'Markus', 'familyName' => 'Ralser')
      expect(subject.contributors).to eq([{ 'contributorType' => 'Editor', 'familyName' => 'Janbon',
                                            'givenName' => 'Guilhem', 'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Triose Phosphate Isomerase Deficiency Is Caused by Altered Dimerization–Not Catalytic Inactivity–of the Mutant Enzymes' }])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2006-12-20', 'updated' => '2021-08-06')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/340',
                                      'name' => 'Public Library of Science (PLoS)')
      expect(subject.references.length).to eq(73)
      expect(subject.references.last).to eq('containerTitle' => 'N Engl J Med', 'creator' => 'KB Hammond',
                                            'doi' => 'https://doi.org/10.1056/nejm199109123251104',
                                            'firstPage' => '769',
                                            'key' => 'ref73',
                                            'publicationYear' => '1991',
                                            'title' => 'Efficacy of statewide neonatal screening for cystic fibrosis by assay of trypsinogen concentrations.', 'volume' => '325')
      expect(subject.container).to eq('firstPage' => 'e30', 'identifier' => '1932-6203',
                                      'identifierType' => 'ISSN', 'issue' => '1', 'title' => 'PLoS ONE', 'type' => 'Journal', 'volume' => '1')
      expect(subject.provider).to eq('Crossref')
    end

    it 'journal article with funding' do
      input = '10.3389/fpls.2019.00816'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.3389/fpls.2019.00816')
      expect(subject.url).to eq('https://www.frontiersin.org/article/10.3389/fpls.2019.00816/full')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(4)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Fortes',
                                           'givenName' => 'Ana Margarida')
      expect(subject.titles).to eq([{ 'title' => 'Transcriptional Modulation of Polyamine Metabolism in Fruit Species Under Abiotic and Biotic Stress' }])
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
      expect(subject.date).to eq('published' => '2019-07-02', 'updated' => '2019-09-22')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/1965',
                                      'name' => 'Frontiers Media SA')
      expect(subject.funding_references).to eq([{ 'awardNumber' => 'CA17111',
                                                  'funderIdentifier' => 'https://doi.org/10.13039/501100000921', 'funderIdentifierType' => 'Crossref Funder ID', 'funderName' => 'COST (European Cooperation in Science and Technology)' }])
      expect(subject.references.length).to eq(70)
      expect(subject.references.first).to eq('containerTitle' => 'Plant Physiol. Biochem.',
                                             'creator' => 'Agudelo-Romero',
                                             'doi' => 'https://doi.org/10.1016/j.plaphy.2013.11.002',
                                             'firstPage' => '141',
                                             'key' => 'ref1',
                                             'publicationYear' => '2014',
                                             'title' => 'Perturbation of polyamine catabolism affects grape ripening of Vitis vinifera cv. Trincadeira',
                                             'volume' => '74')
      expect(subject.references.last).to eq('containerTitle' => 'Acta Hortic.',
                                            'creator' => 'Zheng',
                                            'doi' => 'https://doi.org/10.17660/actahortic.2004.632.41',
                                            'firstPage' => '317',
                                            'key' => 'ref70',
                                            'publicationYear' => '2004',
                                            'title' => 'Effects of polyamines and salicylic acid on postharvest storage of “Ponkan” mandarin',
                                            'volume' => '632')
      expect(subject.container).to eq('identifier' => '1664-462X',
                                      'identifierType' => 'ISSN', 'title' => 'Frontiers in Plant Science', 'type' => 'Journal', 'volume' => '10')
      expect(subject.provider).to eq('Crossref')
    end

    it 'journal article original language title' do
      input = 'https://doi.org/10.7600/jspfsm.56.60'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["property '/creators' is invalid: error_type=minItems"])
      expect(subject.id).to eq('https://doi.org/10.7600/jspfsm.56.60')
      expect(subject.url).to eq('https://www.jstage.jst.go.jp/article/jspfsm/56/1/56_1_60/_article/-char/ja')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.empty?).to be true
      expect(subject.titles).to eq([{ 'title' => ':(unav)' }])
      expect(subject.date).to include('published' => '2007', 'updated' => '2021-05-20')
      expect(subject.references.length).to eq(7)
      expect(subject.references.first).to eq('doi' => 'https://doi.org/10.1111/j.1469-7793.2000.00407.x',
                                             'key' => '1')
      expect(subject.container).to eq('firstPage' => '60', 'identifier' => '1881-4751',
                                      'identifierType' => 'ISSN', 'issue' => '1', 'lastPage' => '60', 'title' => 'Japanese Journal of Physical Fitness and Sports Medicine', 'type' => 'Journal', 'volume' => '56')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/4426',
                                      'name' => 'The Japanese Society of Physical Fitness and Sports Medicine')
      expect(subject.provider).to eq('Crossref')
    end

    it 'journal article with RDF for container' do
      input = 'https://doi.org/10.1163/1937240X-00002096'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1163/1937240x-00002096')
      expect(subject.url).to eq('https://academic.oup.com/jcb/article-lookup/doi/10.1163/1937240X-00002096')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(8)
      expect(subject.creators.first).to eq('familyName' => 'Escrivà',
                                           'givenName' => 'Andreu', 'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Global distribution of Fabaeformiscandona subacuta: an exotic invasive Ostracoda on the Iberian Peninsula?' }])
      expect(subject.date).to include('published' => '2012-01-01')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/286',
                                      'name' => 'Oxford University Press (OUP)')
      expect(subject.references.length).to eq(111)
      expect(subject.references.first).to eq('containerTitle' => 'Rozpravy Ceskoslovenske Akademie Ved, Rada Matematickych A Prirodnich Ved',
                                             'creator' => 'Absolon',
                                             'firstPage' => '1',
                                             'issue' => '5',
                                             'key' => 'bibr1',
                                             'publicationYear' => '1978',
                                             'title' => 'Die Gattung Candonaim Quartar von Europa',
                                             'volume' => '88')
      expect(subject.container).to eq('firstPage' => '949', 'identifier' => '1937-240X',
                                      'identifierType' => 'ISSN', 'issue' => '6', 'lastPage' => '961', 'title' => 'Journal of Crustacean Biology', 'type' => 'Journal', 'volume' => '32')
      expect(subject.provider).to eq('Crossref')
    end

    it 'book chapter with RDF for container' do
      input = 'https://doi.org/10.1007/978-3-642-33191-6_49'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1007/978-3-642-33191-6_49')
      expect(subject.url).to eq('http://link.springer.com/10.1007/978-3-642-33191-6_49')
      expect(subject.type).to eq('BookChapter')
      expect(subject.creators.length).to eq(3)
      expect(subject.creators.first).to eq('familyName' => 'Chen', 'givenName' => 'Lili',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Human Body Orientation Estimation in Multiview Scenarios' }])
      expect(subject.date).to eq('published' => '2012', 'updated' => '2020-11-24')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.references.length).to eq(11)
      expect(subject.references.first).to eq('key' => '49_CR1',
                                             'unstructured' => 'Khan, S., Javed, O., Rasheed, Z., Shah, M.: Human tracking in multiple cameras. In: Proceedings of the 8th IEEE International Conference on Computer Vision, Vancouver, Canada, pp. 331–336 (2001)')
      expect(subject.container).to eq('identifier' => '1611-3349', 'identifierType' => 'ISSN',
                                      'title' => 'Advances in Visual Computing', 'type' => 'Book', 'firstPage' => '499', 'lastPage' => '508')
      expect(subject.provider).to eq('Crossref')
    end

    it 'posted_content' do
      input = 'https://doi.org/10.1101/097196'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('http://biorxiv.org/lookup/doi/10.1101/097196')
      expect(subject.type).to eq('Article')
      expect(subject.creators.count).to eq(11)
      expect(subject.creators.last).to eq('id' => 'https://orcid.org/0000-0003-4060-7360',
                                          'givenName' => 'Timothy', 'familyName' => 'Clark', 'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'A Data Citation Roadmap for Scholarly Data Repositories' }])
      expect(subject.id).to eq('https://doi.org/10.1101/097196')
      expect(subject.descriptions.first['description']).to start_with('AbstractThis article presents a practical roadmap')
      expect(subject.date).to eq('published' => '2016-12-28', 'updated' => '2020-01-18')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/246',
                                      'name' => 'Cold Spring Harbor Laboratory')
      expect(subject.container.empty?).to be(true)
      expect(subject.provider).to eq('Crossref')
    end

    it 'peer review' do
      input = '10.7554/elife.55167.sa2'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('https://elifesciences.org/articles/55167')
      expect(subject.type).to eq('PeerReview')
      expect(subject.creators.count).to eq(8)
      expect(subject.creators.last).to eq('type' => 'Person', 'affiliation' => [{ 'name' => 'Center for Computational Mathematics, Flatiron Institute, New York, United States' }],
                                          'familyName' => 'Barnett',
                                          'givenName' => 'Alex H')
      expect(subject.titles).to eq([{ 'title' => 'Author response: SpikeForest, reproducible web-facing ground-truth validation of automated neural spike sorters' }])
      expect(subject.id).to eq('https://doi.org/10.7554/elife.55167.sa2')
      expect(subject.alternate_identifiers.empty?).to be(true)
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.date).to eq('published' => '2020-04-29', 'updated' => '2020-05-19')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/4374',
                                      'name' => 'eLife Sciences Publications, Ltd')
      expect(subject.provider).to eq('Crossref')
    end

    it 'dissertation' do
      input = '10.14264/uql.2020.791'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('http://espace.library.uq.edu.au/view/UQ:23a1e74')
      expect(subject.type).to eq('Dissertation')
      expect(subject.creators).to eq([{ 'familyName' => 'Collingwood',
                                        'givenName' => 'Patricia Maree',
                                        'id' => 'https://orcid.org/0000-0003-3086-4443',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'School truancy and financial independence during emerging adulthood: a longitudinal analysis of receipt of and reliance on cash transfers' }])
      expect(subject.id).to eq('https://doi.org/10.14264/uql.2020.791')
      expect(subject.alternate_identifiers.empty?).to be(true)
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.date).to eq('published' => '2020-06-08', 'updated' => '2020-06-08')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/5387',
                                      'name' => 'University of Queensland Library')
      expect(subject.provider).to eq('Crossref')
    end

    it 'DOI with SICI DOI' do
      input = '10.1890/0012-9658(2006)87[2832:tiopma]2.0.co;2'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1890/0012-9658(2006)87%255b2832:tiopma%255d2.0.co;2')
      expect(subject.url).to eq('http://doi.wiley.com/10.1890/0012-9658(2006)87%5B2832:TIOPMA%5D2.0.CO;2')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators).to eq([
                                       { 'familyName' => 'Fenton', 'givenName' => 'A.',
                                         'type' => 'Person' }, { 'familyName' => 'Rands', 'givenName' => 'S. A.', 'type' => 'Person' }
                                     ])
      expect(subject.license).to eq('url' => 'http://doi.wiley.com/10.1002/tdm_license_1.1')
      expect(subject.titles).to eq([{ 'title' => 'THE IMPACT OF PARASITE MANIPULATION AND PREDATOR FORAGING BEHAVIOR ON PREDATOR–PREY COMMUNITIES' }])
      expect(subject.date).to eq('published' => '2006-11', 'updated' => '2019-04-28')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/311',
                                      'name' => 'Wiley')
      expect(subject.references.length).to eq(39)
      expect(subject.references.last).to eq('key' => 'i0012-9658-87-11-2832-ydenberg1',
                                            'unstructured' => 'R. C. Ydenberg, 1998 .Behavioral decisions about foraging and predator avoidance .Pages343 -378inR. Dukas, editorCognitive ecology: the evolutionary ecology of information processing and decision making University of Chicago Press, Chicago, Illinois, USA.')
      expect(subject.container).to eq('firstPage' => '2832', 'identifier' => '0012-9658',
                                      'identifierType' => 'ISSN', 'issue' => '11', 'lastPage' => '2841', 'title' => 'Ecology', 'type' => 'Journal', 'volume' => '87')
      expect(subject.provider).to eq('Crossref')
    end

    it 'DOI with ORCID ID' do
      input = 'https://doi.org/10.1155/2012/291294'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1155/2012/291294')
      expect(subject.url).to eq('http://www.hindawi.com/journals/pm/2012/291294')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(7)
      expect(subject.creators[2]).to eq('type' => 'Person',
                                        'id' => 'https://orcid.org/0000-0003-2043-4925',
                                        'givenName' => 'Beatriz', 'familyName' => 'Hernandez', 'affiliation' => [{ 'name' => 'War Related Illness and Injury Study Center (WRIISC) and Mental Illness Research Education and Clinical Center (MIRECC), Department of Veterans Affairs, Palo Alto, CA 94304, USA' }, { 'name' => 'Department of Psychiatry and Behavioral Sciences, Stanford University School of Medicine, Stanford, CA 94304, USA' }])
      expect(subject.license).to eq('id' => 'CC-BY-3.0',
                                    'url' => 'https://creativecommons.org/licenses/by/3.0/legalcode')
      expect(subject.titles).to eq([{ 'title' => 'Delineating a Retesting Zone Using Receiver Operating Characteristic Analysis on Serial QuantiFERON Tuberculosis Test Results in US Healthcare Workers' }])
      expect(subject.date).to include('published' => '2012')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/98',
                                      'name' => 'Hindawi Limited')
      expect(subject.references.length).to eq(27)
      expect(subject.references.last).to eq('doi' => 'https://doi.org/10.1378/chest.12-0045',
                                            'key' => '30')
      expect(subject.container).to eq('firstPage' => '1', 'identifier' => '2090-1844',
                                      'identifierType' => 'ISSN', 'lastPage' => '7', 'title' => 'Pulmonary Medicine', 'type' => 'Journal', 'volume' => '2012')
      expect(subject.provider).to eq('Crossref')
    end

    it 'date in future' do
      input = 'https://doi.org/10.1016/j.ejphar.2015.03.018'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1016/j.ejphar.2015.03.018')
      expect(subject.url).to eq('https://linkinghub.elsevier.com/retrieve/pii/S0014299915002332')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(10)
      expect(subject.creators.first).to eq('type' => 'Person',
                                           'givenName' => 'Sarah E.', 'familyName' => 'Beck')
      expect(subject.titles).to eq([{ 'title' => 'Paving the path to HIV neurotherapy: Predicting SIV CNS disease' }])
      expect(subject.date).to include('published' => '2015-07')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/78',
                                      'name' => 'Elsevier BV')
      expect(subject.references.length).to eq(98)
      expect(subject.references.first).to eq('containerTitle' => 'J. Immunol',
                                             'creator' => 'Allen',
                                             'firstPage' => '6062',
                                             'key' => '10.1016/j.ejphar.2015.03.018_bib1',
                                             'publicationYear' => '1998',
                                             'title' => 'Characterization of the peptide binding motif of a rhesus MHC class I molecule (Mamu-A*01) that binds an immunodominant CTL epitope from simianimmunodeficiency virus.',
                                             'volume' => '160')
      expect(subject.container).to eq('firstPage' => '303', 'identifier' => '0014-2999',
                                      'identifierType' => 'ISSN', 'lastPage' => '312', 'title' => 'European Journal of Pharmacology', 'type' => 'Journal', 'volume' => '759')
      expect(subject.provider).to eq('Crossref')
    end

    it 'vor with url' do
      input = 'https://doi.org/10.1038/hdy.2013.26'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1038/hdy.2013.26')
      expect(subject.url).to eq('http://www.nature.com/articles/hdy201326')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Gross',
                                           'givenName' => 'J B')
      expect(subject.titles).to eq([{ 'title' => 'Albinism in phylogenetically and geographically distinct populations of Astyanax cavefish arises through the same loss-of-function Oca2 allele' }])
      expect(subject.date).to include('published' => '2013-04-10')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.references.size).to eq(41)
      expect(subject.references.first).to eq('containerTitle' => 'An Esc Nac Cien Biol México',
                                             'creator' => 'J Alvarez',
                                             'firstPage' => '263',
                                             'key' => 'BFhdy201326_CR1',
                                             'publicationYear' => '1946',
                                             'unstructured' => 'Alvarez J . (1946). Revisión del género Anoptichthys con descipción de una especie nueva (Pisces, Characidae). An Esc Nac Cien Biol México 4: 263–282.',
                                             'volume' => '4')
      expect(subject.container).to eq('firstPage' => '122', 'identifier' => '1365-2540',
                                      'identifierType' => 'ISSN', 'issue' => '2', 'lastPage' => '130', 'title' => 'Heredity', 'type' => 'Journal', 'volume' => '111')
      expect(subject.provider).to eq('Crossref')
    end

    it 'dataset' do
      input = 'https://doi.org/10.2210/pdb4hhb/pdb'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.2210/pdb4hhb/pdb')
      expect(subject.url).to eq('https://www.wwpdb.org/pdb?id=pdb_00004hhb')
      expect(subject.type).to eq('Component')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq('type' => 'Person', 'givenName' => 'G.',
                                           'familyName' => 'Fermi')
      expect(subject.titles).to eq([{ 'title' => 'THE CRYSTAL STRUCTURE OF HUMAN DEOXYHAEMOGLOBIN AT 1.74 ANGSTROMS RESOLUTION' }])
      expect(subject.descriptions).to eq([])
      expect(subject.date).to include('published' => '1984-07-17')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/7763',
                                      'name' => 'Worldwide Protein Data Bank')
      expect(subject.provider).to eq('Crossref')
    end

    it 'component' do
      input = 'https://doi.org/10.1371/journal.pmed.0030277.g001'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["property '/creators' is invalid: error_type=minItems"])
      expect(subject.id).to eq('https://doi.org/10.1371/journal.pmed.0030277.g001')
      expect(subject.url).to eq('https://dx.plos.org/10.1371/journal.pmed.0030277.g001')
      expect(subject.type).to eq('Component')
      expect(subject.creators.empty?).to be true
      expect(subject.titles).to eq([{ 'title' => ':(unav)' }])
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.date).to eq('published' => '2015-10-20', 'updated' => '2018-10-19')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/340',
                                      'name' => 'Public Library of Science (PLoS)')
      expect(subject.provider).to eq('Crossref')
    end

    it 'dataset usda' do
      input = 'https://doi.org/10.2737/RDS-2018-0001'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.2737/rds-2018-0001')
      expect(subject.url).to eq('https://www.fs.usda.gov/rds/archive/Catalog/RDS-2018-0001')
      expect(subject.type).to eq('Dataset')
      expect(subject.creators.length).to eq(4)
      expect(subject.creators.first).to eq('familyName' => 'Ribic', 'givenName' => 'Christine A.',
                                           'affiliation' => [{ 'name' => 'U.S. Geological Survey' }],
                                           'id' => 'https://orcid.org/0000-0003-2583-1778', 'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Fledging times of grassland birds' }])
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.date).to eq('published' => '2017-08-09', 'updated' => '2021-07-01')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/1450',
                                      'name' => 'USDA Forest Service')
      expect(subject.provider).to eq('Crossref')
    end

    it 'book chapter' do
      input = 'https://doi.org/10.1007/978-3-662-46370-3_13'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1007/978-3-662-46370-3_13')
      expect(subject.url).to eq('https://link.springer.com/10.1007/978-3-662-46370-3_13')
      expect(subject.type).to eq('BookChapter')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq('type' => 'Person',
                                           'givenName' => 'Ronald L.', 'familyName' => 'Diercks')
      expect(subject.titles).to eq([{ 'title' => 'Clinical Symptoms and Physical Examinations' }])
      expect(subject.date).to eq('published' => '2015', 'updated' => '2023-02-10')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.provider).to eq('Crossref')
      expect(subject.container['type']).to eq('Book')
      expect(subject.container['title']).to eq('Shoulder Stiffness')
      expect(subject.container['firstPage']).to eq('155')
      expect(subject.container['lastPage']).to eq('158')
    end

    it 'another book chapter' do
      input = 'https://doi.org/10.1007/978-3-319-75889-3_1'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1007/978-3-319-75889-3_1')
      expect(subject.url).to eq('http://link.springer.com/10.1007/978-3-319-75889-3_1')
      expect(subject.type).to eq('BookChapter')
      expect(subject.creators).to eq([{ 'familyName' => 'Jones', 'givenName' => 'Hunter M.',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Climate Change and Increasing Risk of Extreme Heat' }])
      expect(subject.date).to include('published' => '2018')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.provider).to eq('Crossref')
      expect(subject.container['type']).to eq('Book')
      expect(subject.container['title']).to eq('SpringerBriefs in Medical Earth Sciences')
      expect(subject.container['identifier']).to eq('2523-3629')
      expect(subject.container['identifierType']).to eq('ISSN')
    end

    it 'yet another book chapter' do
      input = 'https://doi.org/10.4018/978-1-4666-1891-6.ch004'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.4018/978-1-4666-1891-6.ch004')
      expect(subject.url).to eq('http://services.igi-global.com/resolvedoi/resolve.aspx?doi=10.4018%2F978-1-4666-1891-6.ch004')
      expect(subject.type).to eq('BookChapter')
      expect(subject.creators).to eq([{ 'type' => 'Person', 'affiliation' => [{ 'name' => 'Université de Lyon, France' }],
                                        'familyName' => 'Bichot', 'givenName' => 'Charles-Edmond' }])
      expect(subject.titles).to eq([{ 'title' => 'Unsupervised and Supervised Image Segmentation Using Graph Partitioning' }])
      expect(subject.date).to eq('published' => '2012-08-08', 'updated' => '2019-07-02')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/2432',
                                      'name' => 'IGI Global')
      expect(subject.provider).to eq('Crossref')
      expect(subject.container['type']).to eq('Book')
      expect(subject.container['title']).to eq('Graph-Based Methods in Computer Vision')
      expect(subject.container['firstPage']).to eq('72')
      expect(subject.container['lastPage']).to eq('94')
    end

    it 'missing creator' do
      input = 'https://doi.org/10.3390/publications6020015'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.3390/publications6020015')
      expect(subject.url).to eq('https://www.mdpi.com/2304-6775/6/2/15')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators).to eq([{ 'familyName' => 'Kohls',
                                        'givenName' => 'Alexander',
                                        'id' => 'https://orcid.org/0000-0002-3836-8885',
                                        'type' => 'Person' },
                                      { 'familyName' => 'Mele',
                                        'givenName' => 'Salvatore',

                                        'id' => 'https://orcid.org/0000-0003-0762-2235',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Converting the Literature of a Scientific Field to Open Access through Global Collaboration: The Experience of SCOAP3 in Particle Physics' }])
      expect(subject.date).to eq('published' => '2018-04-09', 'updated' => '2021-07-22')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/1968',
                                      'name' => 'MDPI AG')
      expect(subject.provider).to eq('Crossref')
    end

    it 'book' do
      input = 'https://doi.org/10.1017/9781108348843'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1017/9781108348843')
      expect(subject.url).to eq('https://www.cambridge.org/core/product/identifier/9781108348843/type/book')
      expect(subject.type).to eq('Book')
      expect(subject.creators).to eq([{ 'type' => 'Person', 'familyName' => 'Leung',
                                        'givenName' => 'Vincent S.' }])
      expect(subject.titles).to eq([{ 'title' => 'The Politics of the Past in Early China' }])
      expect(subject.date).to eq('published' => '2019-07-01', 'updated' => '2022-09-22')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/56',
                                      'name' => 'Cambridge University Press (CUP)')
      expect(subject.provider).to eq('Crossref')
    end

    it 'another book' do
      input = 'https://doi.org/10.2973/odp.proc.ir.180.2000'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.errors).to eq(["property '/creators' is invalid: error_type=minItems"])
      expect(subject.id).to eq('https://doi.org/10.2973/odp.proc.ir.180.2000')
      expect(subject.url).to eq('http://www-odp.tamu.edu/publications/180_IR/180TOC.HTM')
      expect(subject.type).to eq('Book')
      expect(subject.creators.empty?).to be true
      expect(subject.contributors.size).to eq(4)
      expect(subject.contributors.first).to eq('type' => 'Person', 'contributorType' => 'Editor', 'familyName' => 'Taylor',
                                               'givenName' => 'B.')
      expect(subject.titles).to eq([{ 'title' => 'Proceedings of the Ocean Drilling Program, 180 Initial Reports' }])
      expect(subject.date).to eq('published' => '2000-02-04', 'updated' => '2009-02-02')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/1029',
                                      'name' => 'International Ocean Discovery Program (IODP)')
      expect(subject.provider).to eq('Crossref')
    end

    it 'yet another book' do
      input = 'https://doi.org/10.1029/ar035'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1029/ar035')
      expect(subject.url).to eq('http://doi.wiley.com/10.1029/AR035')
      expect(subject.type).to eq('Book')
      expect(subject.creators).to eq([{ 'type' => 'Person', 'familyName' => 'McGinnis',
                                        'givenName' => 'Richard Frank' }])
      expect(subject.titles).to eq([{ 'title' => 'Biogeography of Lanternfishes (Myctophidae) South of 30°S' }])
      expect(subject.date).to eq('published' => '1982', 'updated' => '2021-12-04')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/311',
                                      'name' => 'Wiley')
      expect(subject.references.length).to eq(242)
      expect(subject.references.first).to eq('containerTitle' => 'Palaeogeogr. Palaeoclimatol. Palaeoecol.',
                                             'creator' => 'Addicott',
                                             'doi' => 'https://doi.org/10.1016/0031-0182(70)90103-3',
                                             'firstPage' => '287',
                                             'key' => '10.1029/AR035:addi70',
                                             'publicationYear' => '1970',
                                             'title' => 'Latitudinal gradients in tertiary mol-luscan faunas of the Pacific coast',
                                             'volume' => '8')
      expect(subject.container).to eq('identifier' => '0066-4634', 'identifierType' => 'ISSN',
                                      'title' => 'Antarctic Research Series', 'type' => 'BookSeries')
      expect(subject.provider).to eq('Crossref')
    end

    it 'mEDRA' do
      input = 'https://doi.org/10.3280/ecag2018-001005'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.3280/ecag2018-001005')
      expect(subject.url).to eq('http://www.francoangeli.it/riviste/Scheda_Riviste.asp?IDArticolo=61645')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Oh',
                                           'givenName' => 'Sohae Eve')
      expect(subject.titles).to eq([{ 'title' => 'Substitutability between organic and conventional poultry products and organic price premiums' }])
      expect(subject.date).to include('published' => '2018-05')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/4169',
                                      'name' => 'Franco Angeli')
      expect(subject.provider).to eq('Crossref')
    end

    it 'KISTI' do
      input = 'https://doi.org/10.5012/bkcs.2013.34.10.2889'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5012/bkcs.2013.34.10.2889')
      expect(subject.url).to eq('http://koreascience.or.kr/journal/view.jsp?kj=JCGMCS&py=2013&vnc=v34n10&sp=2889')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(7)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Huang',
                                           'givenName' => 'Guimei')
      expect(subject.titles).to eq([{ 'title' => 'Synthesis, Crystal Structure and Theoretical Calculation of a Novel Nickel(II) Complex with Dibromotyrosine and 1,10-Phenanthroline' }])
      expect(subject.date).to eq('published' => '2013-10-20', 'updated' => '2016-12-15')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/2923',
                                      'name' => 'Korean Chemical Society')
      expect(subject.provider).to eq('KISTI')
    end

    it 'JaLC' do
      input = 'https://doi.org/10.1241/johokanri.39.979'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1241/johokanri.39.979')
      expect(subject.url).to eq('http://joi.jlc.jst.go.jp/JST.JSTAGE/johokanri/39.979?from=CrossRef')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators).to eq([{ 'familyName' => 'KUSUMOTO', 'givenName' => 'Hiroyuki',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Utilizing the Internet. 12 Series. Future of the Internet.' }])
      expect(subject.date).to eq('published' => '1997', 'updated' => '2020-03-06')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/272',
                                      'name' => 'Japan Science and Technology Agency (JST)')
      expect(subject.provider).to eq('JaLC')
    end

    it 'OP' do
      input = 'https://doi.org/10.2903/j.efsa.2018.5239'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.2903/j.efsa.2018.5239')
      expect(subject.url).to eq('http://doi.wiley.com/10.2903/j.efsa.2018.5239')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(28)
      expect(subject.creators.first).to eq(
        'name' => 'EFSA Panel on Food Additives and Nutrient Sources added to Food (ANS)', 'type' => 'Organization'
      )
      expect(subject.titles).to eq([{ 'title' => 'Scientific opinion on the safety of green tea catechins' }])
      expect(subject.date).to include('published' => '2018-04')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/311',
                                      'name' => 'Wiley')
      expect(subject.provider).to eq('OP')
    end

    it 'multiple titles' do
      input = 'https://doi.org/10.4000/dms.865'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.4000/dms.865')
      expect(subject.url).to eq('http://journals.openedition.org/dms/865')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators).to eq([{ 'familyName' => 'Peraya', 'givenName' => 'Daniel',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Distances, absence, proximités et présences : des concepts en déplacement' }])
      expect(subject.date).to include('published' => '2014-12-14')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/2399',
                                      'name' => 'OpenEdition')
      expect(subject.provider).to eq('Crossref')
    end

    it 'multiple titles with missing' do
      input = 'https://doi.org/10.1186/1471-2164-7-187'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1186/1471-2164-7-187')
      expect(subject.url).to eq('https://bmcgenomics.biomedcentral.com/articles/10.1186/1471-2164-7-187')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.size).to eq(5)
      expect(subject.creators.first).to eq('familyName' => 'Myers', 'givenName' => 'Chad L',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Finding function: evaluation methods for functional genomic data' }])
      expect(subject.date).to include('published' => '2006-07-25')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.provider).to eq('Crossref')
    end

    it 'markup' do
      input = 'https://doi.org/10.1098/rspb.2017.0132'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1098/rspb.2017.0132')
      expect(subject.url).to eq('https://royalsocietypublishing.org/doi/10.1098/rspb.2017.0132')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.size).to eq(6)
      expect(subject.creators.first).to eq(
        'affiliation' => [{ 'name' => 'School of Biological Sciences, Centre for Evolutionary Biology, University of Western Australia, Crawley, WA 6009, Australia' }], 'familyName' => 'Dougherty', 'givenName' => 'Liam R.',
        'id' => 'https://orcid.org/0000-0003-1406-0680', 'type' => 'Person'
      )
      expect(subject.titles).to eq([{ 'title' => 'Sexual conflict and correlated evolution between male persistence and female resistance traits in the seed beetle <i>Callosobruchus maculatus</i>' }])
      expect(subject.date).to include('published' => '2017-05-24')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/175',
                                      'name' => 'The Royal Society')
      expect(subject.provider).to eq('Crossref')
    end

    it 'empty given name' do
      input = 'https://doi.org/10.1111/J.1865-1682.2010.01171.X'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1111/j.1865-1682.2010.01171.x')
      expect(subject.url).to eq('https://onlinelibrary.wiley.com/doi/10.1111/j.1865-1682.2010.01171.x')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(5)
      expect(subject.creators[3]).to eq('type' => 'Person', 'familyName' => 'Ehtisham-ul-Haq')
      expect(subject.titles).to eq([{ 'title' => 'Serological Evidence of Brucella abortus Prevalence in Punjab Province, Pakistan - A Cross-Sectional Study' }])
      expect(subject.license).to eq('url' => 'http://doi.wiley.com/10.1002/tdm_license_1.1')
      expect(subject.date).to eq('published' => '2010-09-29', 'updated' => '2023-02-09')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/98',
                                      'name' => 'Hindawi Limited')
    end

    it 'invalid date' do
      input = 'https://doi.org/10.1055/s-0039-1690894'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1055/s-0039-1690894')
      expect(subject.url).to eq('http://www.thieme-connect.de/DOI/DOI?10.1055%2Fs-0039-1690894')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(4)
      expect(subject.creators[1]).to eq('affiliation' => [{ 'name' => 'Department of Chemistry, Tianjin Key Laboratory of Molecular Optoelectronic Sciences, and Tianjin Collaborative Innovation Centre of Chemical Science and Engineering, Tianjin University' }, { 'name' => 'Joint School of National University of Singapore and Tianjin University, International Campus of Tianjin University' }],
                                        'familyName' => 'Ma',
                                        'givenName' => 'Jun-An',
                                        'id' => 'https://orcid.org/0000-0002-3902-6799',
                                        'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Silver-Catalyzed [3+3] Annulation of Glycine Imino Esters with Seyferth–Gilbert Reagent To Access Tetrahydro-1,2,4-triazinecarboxylate Esters' }])
      expect(subject.date).to eq('published' => '2020-04-08', 'updated' => '2020-06-16')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/194',
                                      'name' => 'Georg Thieme Verlag KG')
    end

    it 'journal article with' do
      input = 'https://doi.org/10.1111/nph.14619'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1111/nph.14619')
      expect(subject.url).to eq('https://onlinelibrary.wiley.com/doi/10.1111/nph.14619')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(3)
      expect(subject.creators.first).to eq('affiliation' => [{ 'name' => 'Independent Junior Research Group on Protein Recognition and Degradation; Leibniz Institute of Plant Biochemistry (IPB); Weinberg 3 Halle (Saale) D-06120 Germany' }, { 'name' => 'ScienceCampus Halle - Plant-based Bioeconomy; Betty-Heimann-Strasse 3 Halle (Saale) D-06120 Germany' }],
                                           'familyName' => 'Dissmeyer',
                                           'givenName' => 'Nico',
                                           'id' => 'https://orcid.org/0000-0002-4156-3761',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Life and death of proteins after protease cleavage: protein degradation by the N-end rule pathway' }])
      expect(subject.license).to eq('url' => 'http://doi.wiley.com/10.1002/tdm_license_1.1')
      expect(subject.date).to eq('published' => '2017-06-05', 'updated' => '2021-07-07')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/311',
                                      'name' => 'Wiley')
      expect(subject.references.length).to eq(49)
      expect(subject.references.last).to eq('containerTitle' => 'Proteomics',
                                            'creator' => 'Zhang',
                                            'doi' => 'https://doi.org/10.1002/pmic.201400530',
                                            'firstPage' => '2447',
                                            'key' => '10.1111/nph.14619-BIB0049|nph14619-cit-0049',
                                            'publicationYear' => '2015',
                                            'title' => 'Quantitative proteomics analysis of the Arg/N-end rule pathway of targeted degradation in Arabidopsis roots',
                                            'volume' => '15')
      expect(subject.container).to eq('firstPage' => '929', 'identifier' => '0028-646X',
                                      'identifierType' => 'ISSN', 'issue' => '3', 'lastPage' => '935', 'title' => 'New Phytologist', 'type' => 'Journal', 'volume' => '218')
      expect(subject.provider).to eq('Crossref')
    end

    it 'author literal' do
      input = 'https://doi.org/10.1038/ng.3834'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1038/ng.3834')
      expect(subject.url).to eq('http://www.nature.com/articles/ng.3834')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(14)
      expect(subject.creators[1]).to eq('name' => 'GTEx Consortium', 'type' => 'Organization')
      expect(subject.titles).to eq([{ 'title' => 'The impact of structural variation on human gene expression' }])
      expect(subject.date).to include('published' => '2017-04-03')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.provider).to eq('Crossref')
    end

    it 'affiliation is space' do
      input = 'https://doi.org/10.1177/0042098011428175'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1177/0042098011428175')
      expect(subject.url).to eq('http://journals.sagepub.com/doi/10.1177/0042098011428175')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq('familyName' => 'Petrovici', 'givenName' => 'Norbert',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Workers and the City: Rethinking the Geographies of Power in Post-socialist Urbanisation' }])
      expect(subject.date).to include('published' => '2011-12-22')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/179',
                                      'name' => 'SAGE Publications')
      expect(subject.provider).to eq('Crossref')
    end

    it 'multiple issn' do
      input = 'https://doi.org/10.1007/978-3-642-34922-5_19'
      subject = described_class.new(input: input)
      #  expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1007/978-3-642-34922-5_19')
      expect(subject.url).to eq('https://link.springer.com/10.1007/978-3-642-34922-5_19')
      expect(subject.type).to eq('BookChapter')
      expect(subject.creators.length).to eq(3)
      expect(subject.creators.first).to eq('familyName' => 'Razib', 'givenName' => 'Ali',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Log-Domain Arithmetic for High-Speed Fuzzy Control on a Field-Programmable Gate Array' }])
      expect(subject.date).to include('published' => '2013')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/297',
                                      'name' => 'Springer Science and Business Media LLC')
      expect(subject.container).to eq('identifier' => '1860-0808', 'identifierType' => 'ISSN', 'firstPage' => '269', 'lastPage' => '287',
                                      'title' => 'Soft Computing: State of the Art Theory and Novel Applications', 'type' => 'Book')
      expect(subject.provider).to eq('Crossref')
    end

    it 'article id as page number' do
      input = 'https://doi.org/10.1103/physrevlett.120.117701'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1103/physrevlett.120.117701')
      expect(subject.url).to eq('https://link.aps.org/doi/10.1103/PhysRevLett.120.117701')
      expect(subject.type).to eq('JournalArticle')
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq('familyName' => 'Marrazzo', 'givenName' => 'Antimo',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Prediction of a Large-Gap and Switchable Kane-Mele Quantum Spin Hall Insulator' }])
      expect(subject.date).to include('published' => '2018-03-13')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/16',
                                      'name' => 'American Physical Society (APS)')
      expect(subject.container).to eq('identifier' => '1079-7114',
                                      'identifierType' => 'ISSN', 'issue' => '11', 'title' => 'Physical Review Letters', 'type' => 'Journal', 'volume' => '120')
      expect(subject.provider).to eq('Crossref')
    end

    it 'posted content copernicus' do
      input = 'https://doi.org/10.5194/CP-2020-95'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('https://cp.copernicus.org/preprints/cp-2020-95/cp-2020-95.pdf')
      expect(subject.type).to eq('Article')
      expect(subject.creators.count).to eq(6)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Shao',
                                           'givenName' => 'Jun',
                                           'id' => 'https://orcid.org/0000-0001-6130-6474')
      expect(subject.titles).to eq([{ 'title' => 'The Atmospheric Bridge Communicated the δ&amp;lt;sup&amp;gt;13&amp;lt;/sup&amp;gt;C Decline during the Last Deglaciation to the Global Upper Ocean' }])
      expect(subject.id).to eq('https://doi.org/10.5194/cp-2020-95')
      expect(subject.alternate_identifiers.empty?).to be(true)
      expect(subject.descriptions.first['description']).to start_with('Abstract. During the early last glacial termination')
      expect(subject.date).to include('published' => '2020-07-28')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/3145',
                                      'name' => 'Copernicus GmbH')
      expect(subject.provider).to eq('Crossref')
    end

    it 'book oup' do
      input = '10.1093/oxfordhb/9780198746140.013.5'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('https://academic.oup.com/edited-volume/28081/chapter/212116415')
      expect(subject.type).to eq('Book')
      expect(subject.creators.count).to eq(1)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Clayton',
                                           'givenName' => 'Barbra R.')
      expect(subject.contributors.count).to eq(2)
      expect(subject.contributors.first).to eq('contributorType' => 'Editor', 'familyName' => 'Cozort',
                                               'givenName' => 'Daniel', 'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'The Changing Way of the Bodhisattva' }])
      expect(subject.id).to eq('https://doi.org/10.1093/oxfordhb/9780198746140.013.5')
      expect(subject.alternate_identifiers.empty?).to be(true)
      expect(subject.descriptions.first['description']).to start_with('This chapter explores the nature of the connections')
      expect(subject.date).to include('published' => '2018-04-05')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/286',
                                      'name' => 'Oxford University Press (OUP)')
      expect(subject.provider).to eq('Crossref')
    end

    it 'report osti' do
      input = '10.2172/972169'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.url).to eq('http://www.osti.gov/servlets/purl/972169-1QXROM')
      expect(subject.type).to eq('Report')
      expect(subject.creators.count).to eq(4)
      expect(subject.creators.first).to eq('type' => 'Person', 'familyName' => 'Denholm',
                                           'givenName' => 'P.')
      expect(subject.contributors.count).to eq(0)
      expect(subject.titles).to eq([{ 'title' => 'Role of Energy Storage with Renewable Electricity Generation' }])
      expect(subject.id).to eq('https://doi.org/10.2172/972169')
      expect(subject.descriptions.empty?).to be(true)
      expect(subject.date).to include('published' => '2010-01-01')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/960',
                                      'name' => 'Office of Scientific and Technical Information (OSTI)')
      expect(subject.provider).to eq('Crossref')
    end

    it 'journal issue' do
      input = 'https://doi.org/10.6002/ect.2015.0371'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.id).to eq('https://doi.org/10.6002/ect.2015.0371')
      expect(subject.url).to eq('http://ectrx.org/forms/ectrxcontentshow.php?doi_id=10.6002%2Fect.2015.0371')
      expect(subject.type).to eq('JournalIssue')
      expect(subject.creators.empty?).to be true
      expect(subject.titles).to eq([{ 'title' => ':(unav)' }])
      expect(subject.date).to eq('published' => '2018-10', 'updated' => '2018-10-03')
      expect(subject.publisher).to eq('id' => 'https://api.crossref.org/members/4021',
                                      'name' => 'Baskent University')
      expect(subject.references.length).to eq(1)
      expect(subject.references.first).to eq('containerTitle' => 'Ergonomics',
                                             'creator' => 'IMAMURA',
                                             'doi' => 'https://doi.org/10.1080/001401398186180',
                                             'firstPage' => '1421',
                                             'issue' => '10',
                                             'key' => 'ref0',
                                             'publicationYear' => '1998',
                                             'title' => 'Manual performance in cold conditions while wearing NBC clothing',
                                             'volume' => '41')
      expect(subject.container).to eq('identifier' => '2146-8427', 'identifierType' => 'ISSN',
                                      'issue' => '5', 'title' => 'Experimental and Clinical Transplantation', 'type' => 'Journal', 'volume' => '16')
      expect(subject.provider).to eq('Crossref')
    end

    it 'not found error' do
      input = 'https://doi.org/10.7554/elife.01567x'
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.id).to eq('https://doi.org/10.7554/elife.01567x')
      expect(subject.provider).to eq('Crossref')
      expect(subject.state).to eq('not_found')
    end
  end
end
