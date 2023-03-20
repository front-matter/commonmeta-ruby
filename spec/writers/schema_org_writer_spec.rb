# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  context 'write metadata as schema_org' do
    it 'journal article' do
      input = '10.7554/eLife.01567'
      subject = described_class.new(input: input, from: 'crossref')
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.7554/elife.01567')
      expect(json['@type']).to eq('ScholarlyArticle')
      expect(json['periodical']).to eq('@type' => 'Periodical', 'issn' => '2050-084X',
                                       'name' => 'eLife')
      expect(json['citation'].length).to eq(27)
      expect(json['citation'].first).to eq('@id' => 'https://doi.org/10.1038/nature02100',
                                           '@type' => 'CreativeWork', 'datePublished' => '2003', 'name' => 'APL regulates vascular tissue identity in Arabidopsis')
      expect(json['funder']).to eq([{ '@type' => 'Organization', 'name' => 'SystemsX' },
                                    { '@type' => 'Organization',
                                      'name' => 'EMBO longterm post-doctoral fellowships' },
                                    { '@type' => 'Organization', 'name' => 'Marie Heim-Voegtlin' },
                                    { '@id' => 'https://doi.org/10.13039/501100006390',
                                      '@type' => 'Organization',
                                      'name' => 'University of Lausanne' },
                                    { '@type' => 'Organization', 'name' => 'SystemsX' },
                                    { '@id' => 'https://doi.org/10.13039/501100003043',
                                      '@type' => 'Organization',
                                      'name' => 'EMBO' },
                                    { '@id' => 'https://doi.org/10.13039/501100001711',
                                      '@type' => 'Organization',
                                      'name' => 'Swiss National Science Foundation' },
                                    { '@id' => 'https://doi.org/10.13039/501100006390',
                                      '@type' => 'Organization',
                                      'name' => 'University of Lausanne' }])
      expect(json['license']).to eq('https://creativecommons.org/licenses/by/3.0/legalcode')
    end

    it 'maremma schema.org JSON' do
      input = 'https://github.com/datacite/maremma'
      subject = described_class.new(input: input, from: 'codemeta')
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5438/qeg0-3gm3')
      expect(json['@type']).to eq('SoftwareSourceCode')
      expect(json['name']).to eq('Maremma: a Ruby library for simplified network calls')
      expect(json['author']).to eq('givenName' => 'Martin',
                                   'familyName' => 'Fenner', '@type' => 'Person', '@id' => 'https://orcid.org/0000-0003-0077-4738',
                                   'affiliation' => [{ '@type' => 'Organization', 'name' => 'DataCite' }])
    end

    it 'Schema.org JSON' do
      input = 'https://doi.org/10.5281/ZENODO.48440'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5281/zenodo.48440')
      expect(json['@type']).to eq('SoftwareSourceCode')
      expect(json['name']).to eq('Analysis Tools For Crossover Experiment Of Ui Using Choice Architecture')
      expect(json['license']).to eq('https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode')
    end

    it 'Another Schema.org JSON' do
      input = 'https://doi.org/10.5061/DRYAD.8515'
      subject = described_class.new(input: input, from: 'datacite')
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5061/dryad.8515')
      expect(json['@type']).to eq('Dataset')
      expect(json['license']).to eq('https://creativecommons.org/publicdomain/zero/1.0/legalcode')
      expect(json['keywords']).to eq('Plasmodium, malaria, mitochondrial genome, Parasites')
    end

    it 'Schema.org JSON Cyark' do
      input = 'https://doi.org/10.26301/jgf3-jm06'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.26301/jgf3-jm06')
      expect(json['@type']).to eq('Dataset')
    end

    it 'rdataone' do
      input = "#{fixture_path}codemeta.json"
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5063/f1m61h5x')
      expect(json['@type']).to eq('SoftwareSourceCode')
      expect(json['name']).to eq('R Interface to the DataONE REST API')
      expect(json['author']).to eq([{ 'givenName' => 'Matt',
                                      'familyName' => 'Jones',
                                      '@type' => 'Person',
                                      '@id' => 'https://orcid.org/0000-0003-0077-4738',
                                      'affiliation' => [{ '@type' => 'Organization',
                                                          'name' => 'NCEAS' }] },
                                    { 'givenName' => 'Peter',
                                      'familyName' => 'Slaughter',
                                      '@type' => 'Person',
                                      '@id' => 'https://orcid.org/0000-0002-2192-403X',
                                      'affiliation' => [{ '@type' => 'Organization',
                                                          'name' => 'NCEAS' }] },
                                    { '@type' => 'Organization',
                                      'name' => 'University of California, Santa Barbara' }])
      expect(json['version']).to eq('2.0.0')
      expect(json['keywords']).to eq('data sharing, data repository, dataone')
    end

    it 'Funding' do
      input = 'https://doi.org/10.5438/6423'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5438/6423')
      expect(json['@type']).to eq('CreativeWork')
      expect(json['funder']).to eq('@id' => 'https://doi.org/10.13039/501100000780',
                                   '@type' => 'Organization', 'name' => 'European Commission')
      expect(json['license']).to eq('https://creativecommons.org/licenses/by/4.0/legalcode')
    end

    it 'Funding OpenAIRE' do
      input = 'https://doi.org/10.5281/ZENODO.1239'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.5281/zenodo.1239')
      expect(json['@type']).to eq('Dataset')
      expect(json['funder']).to eq('@id' => 'https://doi.org/10.13039/501100000780',
                                   '@type' => 'Organization', 'name' => 'European Commission')
      expect(json['license']).to eq('https://creativecommons.org/publicdomain/zero/1.0/legalcode')
    end

    it 'subject scheme' do
      input = 'https://doi.org/10.4232/1.2745'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.4232/1.2745')
      expect(json['@type']).to eq('Dataset')
      expect(json['name']).to eq('Flash Eurobarometer 54 (Madrid Summit)')
      expect(json['keywords']).to eq('KAT12 International Institutions, Relations, Conditions, Internationale Politik und Internationale Organisationen, Wirtschaftssysteme und wirtschaftliche Entwicklung, International politics and organisations, Economic systems and development')
    end

    it 'subject scheme multiple keywords' do
      input = 'https://doi.org/10.1594/pangaea.721193'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.1594/pangaea.721193')
      expect(json['@type']).to eq('Dataset')
      expect(json['name']).to eq('Seawater carbonate chemistry and processes during experiments with Crassostrea gigas, 2007')
      expect(json['keywords']).to include('Animalia, Bottles or small containers/Aquaria (&lt;20 L)')
      expect(json['license']).to eq('https://creativecommons.org/licenses/by/3.0/legalcode')
    end

    it 'series information' do
      input = '10.4229/23RDEUPVSEC2008-5CO.8.3'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.4229/23rdeupvsec2008-5co.8.3')
      expect(json['@type']).to eq('CreativeWork')
      expect(json['name']).to eq('Rural Electrification With Hybrid Power Systems Based on Renewables - Technical System Configurations From the Point of View of the European Industry')
      expect(json['author'].count).to eq(3)
      expect(json['author'].first).to eq('@type' => 'Person', 'familyName' => 'Llamas',
                                         'givenName' => 'P.')
      expect(json['periodical']).to eq('@type' => 'Periodical',
                                       'name' => '23rd European Photovoltaic Solar Energy Conference and Exhibition')
    end

    it 'data catalog' do
      input = '10.25491/8KMC-G314'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.25491/8kmc-g314')
      expect(json['@type']).to eq('Dataset')
      expect(json['name']).to eq('Covariates used in eQTL analysis. Includes genotyping principal components and PEER factors')
      expect(json['author']).to eq('@type' => 'Organization', 'name' => 'The GTEx Consortium')
      expect(json['includedInDataCatalog']).to eq('@type' => 'DataCatalog', 'name' => 'GTEx')
      expect(json['identifier']).to eq('@type' => 'PropertyValue', 'propertyID' => 'md5',
                                       'value' => 'c7c89fe7366d50cd75448aa603c9de58')
    end

    it 'alternate identifiers' do
      input = '10.23725/8na3-9s47'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.23725/8na3-9s47')
      expect(json['@type']).to eq('Dataset')
      expect(json['name']).to eq('NWD165827.recab.cram')
      expect(json['author']).to eq('name' => 'TOPMed')
      expect(json['includedInDataCatalog']).to be_empty
      expect(json['identifier']).to eq(
        [{ '@type' => 'PropertyValue',
           'propertyID' => 'minid',
           'value' => 'ark:/99999/fk41CrU4eszeLUDe' },
         { '@type' => 'PropertyValue',
           'propertyID' => 'dataguid',
           'value' => 'dg.4503/c3d66dc9-58da-411c-83c4-dd656aa3c4b7' },
         { '@type' => 'PropertyValue',
           'propertyID' => 'md5',
           'value' => '3b33f6b9338fccab0901b7d317577ea3' }]
      )
    end

    it 'geo_location_box' do
      input = '10.1594/PANGAEA.842237'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.1594/pangaea.842237')
      expect(json['@type']).to eq('Dataset')
      expect(json['name']).to eq('Registry of all stations from the Tara Oceans Expedition (2009-2013)')
      expect(json['author']).to eq([{ '@type' => 'Person', 'familyName' => 'Tara Oceans Consortium',
                                      'givenName' => 'Coordinators' },
                                    { '@type' => 'Person', 'familyName' => 'Tara Oceans Expedition',
                                      'givenName' => 'Participants' }])
      expect(json['includedInDataCatalog']).to be_empty
      expect(json['spatialCoverage']).to eq('@type' => 'Place',
                                            'geo' => {
                                              '@type' => 'GeoShape', 'box' => '-64.3088 -168.5182 79.6753 174.9006'
                                            })
      expect(json['license']).to eq('https://creativecommons.org/licenses/by/3.0/legalcode')
    end

    it 'from schema_org gtex' do
      input = "#{fixture_path}schema_org_gtex.json"
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.25491/d50j-3083')
      expect(json['@type']).to eq('Dataset')
      expect(json['identifier']).to eq('@type' => 'PropertyValue', 'propertyID' => 'md5',
                                       'value' => '687610993')
      expect(json['url']).to eq('https://ors.datacite.org/doi:/10.25491/d50j-3083')
      expect(json['additionalType']).to eq('Gene expression matrices')
      expect(json['name']).to eq('Fully processed, filtered and normalized gene expression matrices (in BED format) for each tissue, which were used as input into FastQTL for eQTL discovery')
      expect(json['version']).to eq('v7')
      expect(json['author']).to eq('@type' => 'Organization', 'name' => 'The GTEx Consortium')
      expect(json['keywords']).to eq('gtex, annotation, phenotype, gene regulation, transcriptomics')
      expect(json['datePublished']).to eq('2017')
      expect(json['contentUrl']).to eq('https://storage.googleapis.com/gtex_analysis_v7/single_tissue_eqtl_data/GTEx_Analysis_v7_eQTL_expression_matrices.tar.gz')
      expect(json['schemaVersion']).to eq('http://datacite.org/schema/kernel-4')
      expect(json['includedInDataCatalog']).to eq('@type' => 'DataCatalog', 'name' => 'GTEx')
      expect(json['publisher']).to eq('@type' => 'Organization', 'name' => 'GTEx')
      expect(json['funder']).to eq([{ '@id' => 'https://doi.org/10.13039/100000052',
                                      'name' => 'Common Fund of the Office of the Director of the NIH',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000054',
                                      'name' => 'National Cancer Institute (NCI)',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000051',
                                      'name' => 'National Human Genome Research Institute (NHGRI)',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000050',
                                      'name' => 'National Heart, Lung, and Blood Institute (NHLBI)',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000026',
                                      'name' => 'National Institute on Drug Abuse (NIDA)',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000025',
                                      'name' => 'National Institute of Mental Health (NIMH)',
                                      '@type' => 'Organization' },
                                    { '@id' => 'https://doi.org/10.13039/100000065',
                                      'name' => 'National Institute of Neurological Disorders and Stroke (NINDS)',
                                      '@type' => 'Organization' }])
      expect(json['provider']).to eq('@type' => 'Organization', 'name' => 'DataCite')
    end

    it 'from schema_org topmed' do
      input = "#{fixture_path}schema_org_topmed.json"
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.23725/8na3-9s47')
      expect(json['@type']).to eq('Dataset')
      expect(json['identifier']).to eq(
        [{ '@type' => 'PropertyValue',
           'propertyID' => 'md5',
           'value' => '3b33f6b9338fccab0901b7d317577ea3' },
         { '@type' => 'PropertyValue',
           'propertyID' => 'minid',
           'value' => 'ark:/99999/fk41CrU4eszeLUDe' },
         { '@type' => 'PropertyValue',
           'propertyID' => 'dataguid',
           'value' => 'dg.4503/c3d66dc9-58da-411c-83c4-dd656aa3c4b7' }]
      )
      expect(json['url']).to eq('https://ors.datacite.org/doi:/10.23725/8na3-9s47')
      expect(json['additionalType']).to eq('CRAM file')
      expect(json['name']).to eq('NWD165827.recab.cram')
      expect(json['author']).to eq('@type' => 'Organization', 'name' => 'TOPMed IRC')
      expect(json['keywords']).to eq('topmed, whole genome sequencing')
      expect(json['datePublished']).to eq('2017-11-30')
      expect(json['contentUrl']).to eq([
                                         's3://cgp-commons-public/topmed_open_access/197bc047-e917-55ed-852d-d563cdbc50e4/NWD165827.recab.cram', 'gs://topmed-irc-share/public/NWD165827.recab.cram'
                                       ])
      expect(json['schemaVersion']).to eq('http://datacite.org/schema/kernel-4')
      expect(json['publisher']).to eq('@type' => 'Organization', 'name' => 'TOPMed')
      expect(json['citation']).to eq([{ '@id' => 'https://doi.org/10.23725/2g4s-qv04',
                                        '@type' => 'CreativeWork' }])
      expect(json['funder']).to eq('@id' => 'https://doi.org/10.13039/100000050',
                                   '@type' => 'Organization', 'name' => 'National Heart, Lung, and Blood Institute (NHLBI)')
      expect(json['provider']).to eq('@type' => 'Organization', 'name' => 'DataCite')
    end

    it 'interactive resource without dates' do
      input = 'https://doi.org/10.34747/g6yb-3412'
      subject = described_class.new(input: input)
      json = JSON.parse(subject.schema_org)
      expect(json['@id']).to eq('https://doi.org/10.34747/g6yb-3412')
      expect(json['@type']).to eq('CreativeWork')
      expect(json['datePublished']).to eq('2019')
    end
  end
end
