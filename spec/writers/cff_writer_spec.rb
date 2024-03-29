# frozen_string_literal: true

require 'spec_helper'

describe Commonmeta::Metadata, vcr: true do
  context 'write metadata as cff' do
    it 'SoftwareSourceCode Zenodo' do
      input = 'https://doi.org/10.5281/zenodo.10164'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json['doi']).to eq('https://doi.org/10.5281/zenodo.10164')
      expect(json['authors']).to eq([{ 'affiliation' => 'Juelich Supercomputing Centre, Jülich, Germany',
                                       'family-names' => 'Klatt',
                                       'given-names' => 'Torbjörn' },
                                     { 'affiliation' => 'Juelich Supercomputing Centre, Jülich, Germany',
                                       'family-names' => 'Moser',
                                       'given-names' => 'Dieter' },
                                     { 'affiliation' => 'Juelich Supercomputing Centre, Jülich, Germany',
                                       'family-names' => 'Speck',
                                       'given-names' => 'Robert' }])
      expect(json['title']).to eq('PyPinT -- Python Framework for Parallel-in-Time Methods')
      expect(json['abstract']).to start_with('<em>PyPinT</em>')
      expect(json['date-released']).to eq('2014')
      expect(json['repository-code']).to eq('https://zenodo.org/record/10164')
      expect(json['keywords']).to eq(['Parallel-in-Time Integration',
                                      'Spectral Deferred Corrections', 'Multigrid', 'Multi-Level Spectral Deferred Corrections', 'Python Framework'])
      expect(json['license']).to eq('MIT')
      # expect(json['references']).to eq('identifiers' => [{ 'type' => 'url',
      #                                                      'value' => 'https://github.com/Parallel-in-Time/PyPinT/tree/release-v0.0.4' }])
    end

    it 'SoftwareSourceCode also Zenodo' do
      input = 'https://doi.org/10.5281/zenodo.15497'
      subject = described_class.new(input: input, from: 'datacite')
      # expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json['doi']).to eq('https://doi.org/10.5281/zenodo.15497')
      expect(json['authors']).to eq([{ 'affiliation' =>
        'Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België',
                                       'family-names' => 'Gins',
                                       'given-names' => 'Wouter' },
                                     { 'affiliation' =>
                                      'Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België',
                                       'family-names' => 'de Groote',
                                       'given-names' => 'Ruben' },
                                     { 'affiliation' =>
                                      'Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België',
                                       'family-names' => 'Heylen',
                                       'given-names' => 'Hanne' }])
      expect(json['title']).to eq('satlas: Simulation and Analysis Toolbox for Laser Spectroscopy and NMR experiments')
      expect(json['abstract']).to eq('Initial release of the satlas Python package for the analysis and simulation for laser spectroscopy experiments. For the documentation, see http://woutergins.github.io/satlas/')
      expect(json['date-released']).to eq('2015')
      expect(json['repository-code']).to eq('https://zenodo.org/record/15497')
      expect(json['keywords'].nil?).to be(true)
      expect(json['license']).to eq('MIT')
      #   expect(json['references']).to eq('identifiers' => [{ 'type' => 'url',
      #                                                        'value' => 'https://github.com/woutergins/satlas/tree/v1.0.0' }])
    end

    it 'ruby-cff' do
      input = 'https://github.com/citation-file-format/ruby-cff'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json['doi']).to eq('https://doi.org/10.5281/zenodo.1184077')
      expect(json['authors']).to eq([{ 'affiliation' => 'The University of Manchester, UK',
                                       'family-names' => 'Haines',
                                       'given-names' => 'Robert',
                                       'orcid' => 'https://orcid.org/0000-0002-9538-7919' },
                                     { 'name' => 'The Ruby Citation File Format Developers' }])
      expect(json['title']).to eq('Ruby CFF Library')
      expect(json['abstract']).to eq('This library provides a Ruby interface to manipulate Citation File Format files')
      expect(json['date-released']).to eq('2023-04-10')
      expect(json['repository-code']).to eq('https://github.com/citation-file-format/ruby-cff')
      expect(json['keywords']).to eq(['Ruby', 'Credit', 'Software citation', 'Research software',
                                      'Software sustainability', 'Metadata', 'Citation file format', 'Cff'])
      expect(json['license']).to eq('Apache-2.0')
      expect(json['references']).to eq('identifiers' => [{ 'type' => 'doi',
                                                           'value' => '10.5281/zenodo.1003149' }])
    end

    it 'Collection of Jupyter notebooks' do
      input = 'https://doi.org/10.14454/fqq6-w751'
      subject = described_class.new(input: input)
      # expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json['doi']).to eq('https://doi.org/10.14454/fqq6-w751')
      expect(json['authors']).to eq([{ 'family-names' => 'Petryszak',
                                       'given-names' => 'Robert',
                                       'orcid' => 'https://orcid.org/0000-0001-6333-2182' },
                                     { 'affiliation' => 'DataCite',
                                       'family-names' => 'Fenner',
                                       'given-names' => 'Martin',
                                       'orcid' => 'https://orcid.org/0000-0003-1419-2405' },
                                     { 'affiliation' => 'Science and Technology Facilities Council',
                                       'family-names' => 'Lambert',
                                       'given-names' => 'Simon',
                                       'orcid' => 'https://orcid.org/0000-0001-9570-8121' },
                                     { 'affiliation' => 'European Bioinformatics Institute',
                                       'family-names' => 'Llinares',
                                       'given-names' => 'Manuel Bernal',
                                       'orcid' => 'https://orcid.org/0000-0002-7368-180X' },
                                     { 'affiliation' => 'British Library',
                                       'family-names' => 'Madden',
                                       'given-names' => 'Frances',
                                       'orcid' => 'https://orcid.org/0000-0002-5432-6116' }])
      expect(json['title']).to eq('FREYA PID Graph Jupyter Notebooks')
      expect(json['abstract']).to eq('Jupyter notebooks that use GraphQL to implement EC-funded FREYA Project PID Graph user stories.')
      expect(json['date-released']).to eq('2020')
      expect(json['repository-code']).to eq('https://github.com/datacite/pidgraph-notebooks-python')
      expect(json['keywords']).to eq(['pid graph', 'pid', 'graphql', 'freya', 'jupyter',
                                      'FOS: Computer and information sciences', 'FOS: Computer and information sciences'])
      expect(json['license']).to be_nil
      # expect(json['references']).to eq(true)
    end
  end
end
