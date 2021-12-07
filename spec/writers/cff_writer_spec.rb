# frozen_string_literal: true

require 'spec_helper'

describe Briard::Metadata, vcr: true do
  context "write metadata as cff" do
    it "SoftwareSourceCode Zenodo" do
      input = "https://doi.org/10.5281/zenodo.10164"
      subject = Briard::Metadata.new(input: input, from: "datacite")
      expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json["doi"]).to eq("https://doi.org/10.5281/zenodo.10164")
      expect(json["authors"]).to eq([{"affiliation"=>[{"name"=>"Juelich Supercomputing Centre, Jülich, Germany"}],
        "familyName"=>"Klatt",
        "givenName"=>"Torbjörn",
        "name"=>"Klatt, Torbjörn"},
       {"affiliation"=>[{"name"=>"Juelich Supercomputing Centre, Jülich, Germany"}],
        "familyName"=>"Moser",
        "givenName"=>"Dieter",
        "name"=>"Moser, Dieter"},
       {"affiliation"=>[{"name"=>"Juelich Supercomputing Centre, Jülich, Germany"}],
        "familyName"=>"Speck",
        "givenName"=>"Robert",
        "name"=>"Speck, Robert"}])
      expect(json["title"]).to eq("Pypint -- Python Framework For Parallel-In-Time Methods")
      expect(json["abstract"]).to eq("<em>PyPinT</em> is a framework for Parallel-in-Time integration routines. The main purpose of <em>PyPinT</em> is to provide a framework for educational use and prototyping new parallel-in-time algorithms. As well it will aid in developing a high-performance C++ implementation for massively parallel computers providing the benefits of parallel-in-time routines to a zoo of time integrators in various applications.")
      expect(json["date-released"]).to eq("2014-05-27")
      expect(json["repository-code"]).to eq("https://zenodo.org/record/10164")
      expect(json["keywords"]).to eq(["Parallel-in-Time Integration", "Spectral Deferred Corrections", "Multigrid", "Multi-Level Spectral Deferred Corrections", "Python Framework"])
      expect(json["license"]).to eq(["http://www.opensource.org/licenses/MIT", "info:eu-repo/semantics/openAccess"])
    end

    it "SoftwareSourceCode also Zenodo" do
      input = "https://doi.org/10.5281/zenodo.15497"
      subject = Briard::Metadata.new(input: input, from: "datacite")
      expect(subject.valid?).to be true
      json = Psych.safe_load(subject.cff, permitted_classes: [Date])
      expect(json["doi"]).to eq("https://doi.org/10.5281/zenodo.15497")
      expect(json["authors"]).to eq([{"affiliation"=>
        [{"name"=>
          "Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België"}],
          "familyName"=>"Gins",
          "givenName"=>"Wouter",
          "name"=>"Gins, Wouter"},
         {"affiliation"=>
        [{"name"=>
          "Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België"}],
          "familyName"=>"de Groote",
          "givenName"=>"Ruben",
          "name"=>"de Groote, Ruben"},
         {"affiliation"=>
        [{"name"=>
          "Instituut voor Kern- en Stralingsfysica, KU Leuven, 3001 Leuven, België"}],
          "familyName"=>"Heylen",
          "givenName"=>"Hanne",
          "name"=>"Heylen, Hanne"}])
      expect(json["title"]).to eq("Satlas: Simulation And Analysis Toolbox For Laser Spectroscopy And Nmr Experiments")
      expect(json["abstract"]).to eq("Initial release of the satlas Python package for the analysis and simulation for laser spectroscopy experiments. For the documentation, see http://woutergins.github.io/satlas/")
      expect(json["date-released"]).to eq("2015-02-18")
      expect(json["repository-code"]).to eq("https://zenodo.org/record/15497")
      expect(json["keywords"]).to be_nil
      expect(json["license"]).to eq(["http://www.opensource.org/licenses/MIT", "info:eu-repo/semantics/openAccess"])
    end
  end
end
