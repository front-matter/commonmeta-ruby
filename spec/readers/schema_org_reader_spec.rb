# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  let(:fixture_path) { 'spec/fixtures/' }

  context 'get schema_org raw' do
    it 'BlogPosting' do
      input = "#{fixture_path}schema_org.json"
      subject = described_class.new(input: input)
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context 'get schema_org metadata' do
    it 'BlogPosting' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.53731/r79vxn1-97aq74v-ag58n')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/eating-your-own-dog-food')
      expect(subject.type).to eq('Article')
      expect(subject.creators).to eq([{ 'familyName' => 'Fenner',
                                        'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-1419-2405',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Eating your own Dog Food' }])
      expect(subject.descriptions.first['description']).to start_with('Eating your own dog food')
      expect(subject.subjects).to eq([{ 'subject' => 'Feature' }])
      expect(subject.date).to eq('published' => '2016-12-20T00:00:00Z',
                                 'updated' => '2022-08-15T09:06:22Z')
      expect(subject.references.length).to eq(0)
      expect(subject.publisher).to eq('name' => 'Front Matter')
    end

    it 'BlogPosting with new DOI' do
      input = 'https://blog.front-matter.io/posts/eating-your-own-dog-food'
      subject = described_class.new(input: input, doi: '10.5438/0000-00ss')
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5438/0000-00ss')
      expect(subject.url).to eq('https://blog.front-matter.io/posts/eating-your-own-dog-food')
      expect(subject.type).to eq('Article')
    end

    it 'BlogPosting with type as array' do
      input = "#{fixture_path}schema_org_type_as_array.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(subject.url).to eq('https://blog.datacite.org/eating-your-own-dog-food')
      expect(subject.type).to eq('Article')
      expect(subject.creators).to eq([{ 'affiliation' => [{ 'name' => 'DataCite' }],
                                        'familyName' => 'Fenner', 'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-1419-2405',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Eating your own Dog Food' }])
      expect(subject.descriptions.first['description']).to start_with('Eating your own dog food')
      expect(subject.subjects).to eq([{ 'subject' => 'Datacite' }, { 'subject' => 'Doi' },
                                      { 'subject' => 'Metadata' }, { 'subject' => 'Featured' }])
      expect(subject.date).to eq('created' => '2016-12-20',
                                 'published' => '2016-12-20',
                                 'updated' => '2016-12-20')
      expect(subject.references.length).to eq(2)
      expect(subject.references.last).to eq('doi' => '10.5438/55e5-t5c0',
                                            'key' => 'https://doi.org/10.5438/55e5-t5c0')
      expect(subject.publisher).to eq('name' => 'DataCite')
    end

    context 'get schema_org metadata front matter' do
      it 'BlogPosting' do
        input = 'https://blog.front-matter.io/posts/step-forward-for-software-citation'
        subject = described_class.new(input: input)
        # expect(subject.valid?).to be true
        expect(subject.id).to eq('https://doi.org/10.53731/r9531p1-97aq74v-ag78v')
        expect(subject.url).to eq('https://blog.front-matter.io/posts/step-forward-for-software-citation')
        expect(subject.type).to eq('Article')
        expect(subject.creators).to eq([{ 'familyName' => 'Fenner',
                                          'givenName' => 'Martin',
                                          'id' => 'https://orcid.org/0000-0003-1419-2405',
                                          'type' => 'Person' }])
        expect(subject.titles).to eq([{ 'title' => 'A step forward for software citation: GitHub&#x27;s enhanced software citation support' }])
        expect(subject.descriptions.first['description']).to start_with('On August 19, GitHub announced software citation')
        expect(subject.subjects).to eq([{ 'subject' => 'News' }])
        expect(subject.date).to eq('published' => '2021-08-24T16:57:24Z',
                                   'updated' => '2022-08-15T19:05:14Z')
        expect(subject.references.length).to eq(0)
        expect(subject.container).to eq("identifier"=>"https://blog.front-matter.io/", "identifierType"=>"URL", "title"=>"Front Matter", "type"=>"Periodical")
        expect(subject.publisher).to eq('name' => 'Front Matter')
      end
    end

    it 'zenodo' do
      input = 'https://www.zenodo.org/record/1196821'
      subject = described_class.new(input: input, from: 'schema_org')
      # expect(subject.valid?).to be true
      expect(subject.language).to eq('eng')
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1196821')
      expect(subject.url).to eq('https://zenodo.org/record/1196821')
      expect(subject.type).to eq('Dataset')
      expect(subject.titles).to eq([{ 'title' => 'PsPM-SC4B: SCR, ECG, EMG, PSR and respiration measurements in a delay fear conditioning task with auditory CS and electrical US' }])
      expect(subject.creators.size).to eq(6)
      expect(subject.creators.first).to eq('type' => 'Person', 'givenName' => 'Matthias',
                                           'familyName' => 'Staib', 'id' => 'https://orcid.org/0000-0001-9688-838X', 'affiliation' => [{ 'name' => 'University of Zurich, Zurich, Switzerland' }])
      expect(subject.publisher).to eq('name' => 'Zenodo')
      expect(subject.subjects).to eq([{ 'subject' => 'Pupil size response' },
                                      { 'subject' => 'Skin conductance response' },
                                      { 'subject' => 'Electrocardiogram' },
                                      { 'subject' => 'Electromyogram' },
                                      { 'subject' => 'Electrodermal activity' },
                                      { 'subject' => 'Galvanic skin response' },
                                      { 'subject' => 'Psr' },
                                      { 'subject' => 'Scr' },
                                      { 'subject' => 'Ecg' },
                                      { 'subject' => 'Emg' },
                                      { 'subject' => 'Eda' },
                                      { 'subject' => 'Gsr' }])
    end

    it 'pangaea' do
      input = 'https://doi.pangaea.de/10.1594/PANGAEA.836178'
      subject = described_class.new(input: input, from: 'schema_org')
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.1594/pangaea.836178')
      expect(subject.url).to eq('https://doi.pangaea.de/10.1594/PANGAEA.836178')
      expect(subject.type).to eq('Dataset')
      expect(subject.titles).to eq([{ 'title' => 'Hydrological and meteorological investigations in a lake near Kangerlussuaq, west Greenland' }])
      expect(subject.creators.size).to eq(8)
      expect(subject.creators.first).to eq('type' => 'Person',
                                           'givenName' => 'Emma', 'familyName' => 'Johansson')
      expect(subject.publisher).to eq('name' => 'PANGAEA')
    end

    # TODO: check redirections
    # it "ornl" do
    #   input = "https://doi.org/10.3334/ornldaac/1339"
    #   subject = Commonmeta::Metadata.new(input: input, from: "schema_org")
    #   # expect(subject.valid?).to be true
    #   expect(subject.id).to eq("https://doi.org/10.3334/ornldaac/1339")
    #   expect(subject.url).to eq("https://doi.org/10.3334/ornldaac/1339")
    #   expect(subject.type).to eq("bibtex"=>"misc", "citeproc"=>"article-journal", "ris"=>"GEN", "schemaOrg"=>"DataSet")
    #   expect(subject.titles).to eq([{"title"=>"Soil Moisture Profiles and Temperature Data from SoilSCAPE Sites, USA"}])
    #   expect(subject.creators.size).to eq(12)
    #   expect(subject.creators.first).to eq("familyName"=>"MOGHADDAM", "givenName"=>"M.", "name"=>"MOGHADDAM, M.", "type"=>"Person", "nameIdentifiers"=>[], "affiliation" => [])
    # end

    it 'harvard dataverse' do
      input = 'https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/NJ7XSO'
      subject = described_class.new(input: input, from: 'schema_org')
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.7910/dvn/nj7xso')
      expect(subject.type).to eq('Dataset')
      expect(subject.titles).to eq([{ 'title' => 'Summary data ankylosing spondylitis GWAS' }])
      expect(subject.container).to eq('identifier' => 'https://dataverse.harvard.edu',
                                      'identifierType' => 'URL', 'title' => 'Harvard Dataverse', 'type' => 'DataRepository')
      expect(subject.creators).to eq([{
                                       'name' => 'International Genetics of Ankylosing Spondylitis Consortium (IGAS)'
                                     }])
      expect(subject.subjects).to eq([{ 'subject' => 'Medicine, health and life sciences' },
                                      { 'subject' => 'genome-wide association studies' },
                                      { 'subject' => 'Ankylosing spondylitis' }])
    end

    it 'upstream blog' do
      input = 'https://upstream.force11.org/elife-reviewed-preprints-interview-with-fiona-hutton'
      subject = described_class.new(input: input, from: 'schema_org')
      expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.54900/8d7emer-rm2pg72')
      expect(subject.type).to eq('Article')
      expect(subject.titles).to eq([{ 'title' => 'eLife Reviewed Preprints: Interview with Fiona Hutton' }])
      expect(subject.container).to eq('identifier' => 'https://upstream.force11.org/',
                                      'identifierType' => 'URL', 'title' => 'Upstream', 'type' => 'Periodical')
      expect(subject.creators.size).to eq(2)
      expect(subject.creators.first).to eq('familyName' => 'Hutton',
                                           'givenName' => 'Fiona',
                                           'type' => 'Person')
      expect(subject.subjects).to eq([{ 'subject' => 'Interviews' }])
      expect(subject.publisher).to eq('name' => 'Upstream')
      expect(subject.date).to eq('published' => '2022-11-15T10:29:38Z',
                                 'updated' => '2023-06-17T20:18:54Z')
      expect(subject.license).to eq('id' => 'CC-BY-4.0',
                                    'url' => 'https://creativecommons.org/licenses/by/4.0/legalcode')
    end

    # TODO: check 403 status in DOI resolver
    # it "harvard dataverse via identifiers.org" do
    #   input = "https://identifiers.org/doi/10.7910/DVN/NJ7XSO"
    #   subject = Commonmeta::Metadata.new(input: input, from: "schema_org")
    #   # expect(subject.valid?).to be true
    #   expect(subject.id).to eq("https://doi.org/10.7910/dvn/nj7xso")
    #   expect(subject.type).to eq("bibtex"=>"misc", "citeproc"=>"dataset", "resourceTypeGeneral"=>"Dataset", "ris"=>"DATA", "schemaOrg"=>"Dataset")
    #   expect(subject.titles).to eq([{"title"=>"Summary data ankylosing spondylitis GWAS"}])
    #   expect(subject.container).to eq("identifier"=>"https://dataverse.harvard.edu", "identifierType"=>"URL", "title"=>"Harvard Dataverse", "type"=>"DataRepository")
    #   expect(subject.creators).to eq([{"name" => "International Genetics Of Ankylosing Spondylitis Consortium (IGAS)", "nameIdentifiers"=>[], "affiliation" => []}])
    # end
  end

  context 'get schema_org metadata as string' do
    it 'BlogPosting' do
      input = "#{fixture_path}schema_org.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.language).to eq('en')
      expect(subject.id).to eq('https://doi.org/10.5438/4k3m-nyvg')
      expect(subject.url).to eq('https://blog.datacite.org/eating-your-own-dog-food')
      expect(subject.type).to eq('Article')
      expect(subject.creators).to eq([{ 'familyName' => 'Fenner', 'givenName' => 'Martin',
                                        'id' => 'https://orcid.org/0000-0003-1419-2405',
                                        'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Eating your own Dog Food' }])
      expect(subject.descriptions.first['description']).to start_with('Eating your own dog food')
      expect(subject.subjects).to eq([{ 'subject' => 'Datacite' }, { 'subject' => 'Doi' },
                                      { 'subject' => 'Metadata' }, { 'subject' => 'Featured' }])
      expect(subject.date).to eq('created' => '2016-12-20',
                                 'published' => '2016-12-20',
                                 'updated' => '2016-12-20')
      expect(subject.references.length).to eq(2)
      expect(subject.references.last).to eq('doi' => '10.5438/55e5-t5c0',
                                            'key' => 'https://doi.org/10.5438/55e5-t5c0')
      expect(subject.publisher).to eq('name' => 'DataCite')
    end

    it 'GTEx dataset' do
      input = "#{fixture_path}schema_org_gtex.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.25491/d50j-3083')
      expect(subject.alternate_identifiers).to eq([{ 'alternateIdentifier' => '687610993',
                                                     'alternateIdentifierType' => 'md5' }])
      expect(subject.url).to eq('https://ors.datacite.org/doi:/10.25491/d50j-3083')
      expect(subject.content_url).to eq(['https://storage.googleapis.com/gtex_analysis_v7/single_tissue_eqtl_data/GTEx_Analysis_v7_eQTL_expression_matrices.tar.gz'])
      expect(subject.type).to eq('Dataset')
      expect(subject.creators).to eq([{ 'name' => 'The GTEx Consortium',
                                        'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'Fully processed, filtered and normalized gene expression matrices (in BED format) for each tissue, which were used as input into FastQTL for eQTL discovery' }])
      expect(subject.version).to eq('v7')
      expect(subject.subjects).to eq([{ 'subject' => 'Gtex' }, { 'subject' => 'Annotation' },
                                      { 'subject' => 'Phenotype' }, { 'subject' => 'Gene regulation' }, { 'subject' => 'Transcriptomics' }])
      expect(subject.date).to eq('published' => '2017')
      expect(subject.container).to eq('title' => 'GTEx', 'type' => 'DataRepository')
      expect(subject.publisher).to eq('name' => 'GTEx')
      expect(subject.funding_references.length).to eq(7)
      expect(subject.funding_references.first).to eq(
        'funderIdentifier' => 'https://doi.org/10.13039/100000052', 'funderIdentifierType' => 'Crossref Funder ID', 'funderName' => 'Common Fund of the Office of the Director of the NIH'
      )
    end

    it 'TOPMed dataset' do
      input = "#{fixture_path}schema_org_topmed.json"
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.alternate_identifiers).to eq([{ 'alternateIdentifier' => '3b33f6b9338fccab0901b7d317577ea3',
                                                     'alternateIdentifierType' => 'md5' },
                                                   { 'alternateIdentifier' => 'ark:/99999/fk41CrU4eszeLUDe',
                                                     'alternateIdentifierType' => 'minid' },
                                                   { 'alternateIdentifier' => 'dg.4503/c3d66dc9-58da-411c-83c4-dd656aa3c4b7',
                                                     'alternateIdentifierType' => 'dataguid' }])
      expect(subject.url).to eq('https://ors.datacite.org/doi:/10.23725/8na3-9s47')
      expect(subject.content_url).to eq([
                                          's3://cgp-commons-public/topmed_open_access/197bc047-e917-55ed-852d-d563cdbc50e4/NWD165827.recab.cram', 'gs://topmed-irc-share/public/NWD165827.recab.cram'
                                        ])
      expect(subject.type).to eq('Dataset')
      expect(subject.creators).to eq([{ 'name' => 'TOPMed IRC', 'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'NWD165827.recab.cram' }])
      expect(subject.subjects).to eq([{ 'subject' => 'Topmed' },
                                      { 'subject' => 'Whole genome sequencing' }])
      expect(subject.date).to eq('published' => '2017-11-30')
      expect(subject.publisher).to eq('name' => 'TOPMed')
      expect(subject.references).to eq([{ 'doi' => '10.23725/2g4s-qv04',
                                          'key' => 'https://doi.org/10.23725/2g4s-qv04' }])
      expect(subject.funding_references).to eq([{
                                                 'funderIdentifier' => 'https://doi.org/10.13039/100000050', 'funderIdentifierType' => 'Crossref Funder ID', 'funderName' => 'National Heart, Lung, and Blood Institute (NHLBI)'
                                               }])
    end

    it 'tdl_iodp dataset' do
      input = "#{fixture_path}schema_org_tdl_iodp_invalid_authors.json"
      subject = described_class.new(input: input)
      expect(subject.valid?).to be false
    end

    it 'geolocation' do
      input = "#{fixture_path}schema_org_geolocation.json"
      subject = described_class.new(input: input)

      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.6071/z7wc73')
      expect(subject.alternate_identifiers).to be_nil
      expect(subject.type).to eq('Dataset')
      expect(subject.creators.length).to eq(6)
      expect(subject.creators.first).to eq('familyName' => 'Bales', 'givenName' => 'Roger',
                                           'type' => 'Person')
      expect(subject.titles).to eq([{ 'title' => 'Southern Sierra Critical Zone Observatory (SSCZO), Providence Creek meteorological data, soil moisture and temperature, snow depth and air temperature' }])
      expect(subject.subjects).to eq([{ 'subject' => 'Earth sciences' },
                                      { 'subject' => 'Soil moisture' },
                                      { 'subject' => 'Soil temperature' },
                                      { 'subject' => 'Snow depth' },
                                      { 'subject' => 'Air temperature' },
                                      { 'subject' => 'Water balance' },
                                      { 'subject' => 'Nevada' },
                                      { 'subject' => 'Sierra (mountain range)' }])
      expect(subject.date).to eq('published' => '2013', 'updated' => '2014-10-17')
      expect(subject.publisher).to eq('name' => 'UC Merced')
      expect(subject.funding_references).to eq([{ 'funderName' => 'National Science Foundation, Division of Earth Sciences, Critical Zone Observatories' }])
      expect(subject.geo_locations).to eq([{
                                            'geoLocationPlace' => 'Providence Creek (Lower, Upper and P301)', 'geoLocationPoint' => {
                                              'pointLatitude' => '37.047756', 'pointLongitude' => '-119.221094'
                                            }
                                          }])
    end

    it 'geolocation geoshape' do
      input = "#{fixture_path}schema_org_geoshape.json"
      subject = described_class.new(input: input)

      # expect(subject.valid?).to be true
      expect(subject.language).to eq('en')
      expect(subject.id).to eq('https://doi.org/10.1594/pangaea.842237')
      expect(subject.type).to eq('Dataset')
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq('name' => 'Tara Oceans Consortium, Coordinators',
                                           'type' => 'Organization')
      expect(subject.titles).to eq([{ 'title' => 'Registry of all stations from the Tara Oceans Expedition (2009-2013)' }])
      expect(subject.date).to eq('published' => '2015-02-03')
      expect(subject.publisher).to eq('name' => 'PANGAEA')
      expect(subject.geo_locations).to eq([{ 'geoLocationBox' => { 'eastBoundLongitude' => '174.9006',
                                                                   'northBoundLatitude' => '79.6753', 'southBoundLatitude' => '-64.3088', 'westBoundLongitude' => '-168.5182' } }])
    end

    it 'schema_org list' do
      data = File.read("#{fixture_path}schema_org_list.json").strip
      input = JSON.parse(data).first.to_json
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.23725/7jg3-v803')
      expect(subject.alternate_identifiers).to eq([{ 'alternateIdentifier' => 'ark:/99999/fk4E1n6n1YHKxPk',
                                                     'alternateIdentifierType' => 'minid' },
                                                   { 'alternateIdentifier' => 'dg.4503/01b048d0-e128-4cb0-94e9-b2d2cab7563d',
                                                     'alternateIdentifierType' => 'dataguid' },
                                                   { 'alternateIdentifier' => 'f9e72bdf25bf4b4f0e581d9218fec2eb',
                                                     'alternateIdentifierType' => 'md5' }])
      expect(subject.url).to eq('https://ors.datacite.org/doi:/10.23725/7jg3-v803')
      expect(subject.content_url).to eq([
                                          's3://cgp-commons-public/topmed_open_access/44a8837b-4456-5709-b56b-54e23000f13a/NWD100953.recab.cram', 'gs://topmed-irc-share/public/NWD100953.recab.cram', 'dos://dos.commons.ucsc-cgp.org/01b048d0-e128-4cb0-94e9-b2d2cab7563d?version=2018-05-26T133719.491772Z'
                                        ])
      expect(subject.type).to eq('Dataset')
      expect(subject.creators).to eq([{ 'name' => 'TOPMed', 'type' => 'Organization' }])
      expect(subject.titles).to eq([{ 'title' => 'NWD100953.recab.cram' }])
      expect(subject.subjects).to eq([{ 'subject' => 'Topmed' },
                                      { 'subject' => 'Whole genome sequencing' }])
      expect(subject.date).to eq('published' => '2017-11-30')
      expect(subject.publisher).to eq('name' => 'TOPMed')
      expect(subject.funding_references).to eq([{
                                                 'funderIdentifier' => 'https://doi.org/10.13039/100000050', 'funderIdentifierType' => 'Crossref Funder ID', 'funderName' => 'National Heart, Lung, and Blood Institute (NHLBI)'
                                               }])
    end

    it 'aida dataset' do
      input = "#{fixture_path}aida.json"
      subject = described_class.new(input: input)

      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.23698/aida/drov')
      expect(subject.url).to eq('https://doi.aida.medtech4health.se/10.23698/aida/drov')
      expect(subject.type).to eq('Dataset')
      # expect(subject.creators).to eq([{"familyName"=>"Lindman", "givenName"=>"Karin", "name"=>"Lindman, Karin", "nameIdentifiers"=>[{"nameIdentifier"=> "https://orcid.org/0000-0003-1298-517X", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "type"=>"Person"}])
      expect(subject.titles).to eq([{ 'title' => 'Ovary data from the Visual Sweden project DROID' }])
      expect(subject.version).to eq('1.0')
      expect(subject.subjects).to eq([{ 'subject' => 'Pathology' }, { 'subject' => 'Whole slide imaging' },
                                      { 'subject' => 'Annotated' }])
      expect(subject.date).to eq('created' => '2019-01-09',
                                 'published' => '2019-01-09',
                                 'updated' => '2019-01-09')
      expect(subject.id).to eq('https://doi.org/10.23698/aida/drov')
      expect(subject.publisher).to eq('name' => 'AIDA')
      expect(subject.license).to eq('url' => 'https://datasets.aida.medtech4health.se/10.23698/aida/drov#license')
    end

    it 'from attributes' do
      subject = described_class.new(input: nil,
                                    from: 'schema_org',
                                    doi: '10.5281/zenodo.1239',
                                    creators: [{ 'type' => 'Person', 'name' => 'Jahn, Najko', 'givenName' => 'Najko',
                                                 'familyName' => 'Jahn' }],
                                    titles: [{ 'title' => 'Publication Fp7 Funding Acknowledgment - Plos Openaire' }],
                                    descriptions: [{
                                      'description' => 'The dataset contains a sample of metadata describing papers', 'descriptionType' => 'Abstract'
                                    }],
                                    publisher: { 'name' => 'Zenodo' },
                                    date: { 'published' => '2013-04-03' },
                                    funding_references: [{ 'awardNumber' => '246686',
                                                           'awardTitle' => 'Open Access Infrastructure for Research in Europe',
                                                           'awardUri' => 'info:eu-repo/grantAgreement/EC/FP7/246686/',
                                                           'funderIdentifier' => 'https://doi.org/10.13039/501100000780',
                                                           'funderIdentifierType' => 'Crossref Funder ID',
                                                           'funderName' => 'European Commission' }],
                                    type: 'Dataset')
      # expect(subject.valid?).to be true
      expect(subject.id).to eq('https://doi.org/10.5281/zenodo.1239')
      expect(subject.type).to eq('Dataset')
      expect(subject.creators).to eq([{ 'familyName' => 'Jahn', 'givenName' => 'Najko',
                                        'name' => 'Jahn, Najko', 'type' => 'Person' }])
      expect(subject.titles).to eq([{ 'title' => 'Publication Fp7 Funding Acknowledgment - Plos Openaire' }])
      expect(subject.descriptions.first['description']).to start_with('The dataset contains a sample of metadata describing papers')
      expect(subject.date).to eq('published' => '2013-04-03')
      expect(subject.publisher).to eq('name' => 'Zenodo')
      expect(subject.funding_references).to eq([{ 'awardNumber' => '246686',
                                                  'awardTitle' => 'Open Access Infrastructure for Research in Europe',
                                                  'awardUri' => 'info:eu-repo/grantAgreement/EC/FP7/246686/',
                                                  'funderIdentifier' => 'https://doi.org/10.13039/501100000780',
                                                  'funderIdentifierType' => 'Crossref Funder ID',
                                                  'funderName' => 'European Commission' }])
    end
  end
end
