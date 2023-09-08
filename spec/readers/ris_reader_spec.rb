# frozen_string_literal: true

require "spec_helper"

describe Commonmeta::Metadata, vcr: true do
  subject { described_class.new(input: input) }

  let(:input) { "#{fixture_path}crossref.ris" }

  context "detect format" do
    it "extension" do
      # expect(subject.valid?).to be true
    end

    it "string" do
      described_class.new(input: File.read(input).strip)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
    end
  end

  context "get ris raw" do
    it "Crossref DOI" do
      expect(subject.raw).to eq(File.read(input).strip)
    end
  end

  context "get ris metadata" do
    it "Crossref DOI" do
      expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.type).to eq("JournalArticle")
      expect(subject.url).to eq("http://elifesciences.org/lookup/doi/10.7554/eLife.01567")
      expect(subject.contributors.length).to eq(5)
      expect(subject.contributors.first).to eq("type" => "Person", "contributorRoles" => ["Author"],
                                               "givenName" => "Martial",
                                               "familyName" => "Sankar")
      expect(subject.titles).to eq([{ "title" => "Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth" }])
      expect(subject.descriptions.first["description"]).to start_with("Among various advantages, their small size makes model organisms preferred subjects of investigation.")
      expect(subject.date).to eq("published" => "2014")
      expect(subject.container).to eq("identifier" => "2050084X", "title" => "eLife",
                                      "type" => "Journal", "volume" => "3")
    end

    it "DOI does not exist" do
      input = "#{fixture_path}pure.ris"
      doi = "10.7554/elife.01567"
      subject = described_class.new(input: input, doi: doi)
      expect(subject.valid?).to be false
      expect(subject.state).to eq("not_found")
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.type).to eq("Dissertation")
      expect(subject.contributors).to eq([{ "familyName" => "Toparlar", "givenName" => "Y.", "type" => "Person", "contributorRoles" => ["Author"] }])
      expect(subject.titles).to eq([{ "title" => "A multiscale analysis of the urban heat island effect" }])
      expect(subject.descriptions.first["description"]).to start_with("Designing the climates of cities")
      expect(subject.date).to eq("created" => "2018-04-25", "published" => "2018-04-25")
    end

    it "RIS with Dashes" do
      input = "#{fixture_path}ris_bug.ris"
      abs = "3D image based subject specific models of the ankle complex can be extremely significant in a wide variety of clinical and biomechanical applications such as evaluating the effect of ligament ruptures, diagnosing and comparing surgical procedures. However, there are very few computational models that can accurately capture the full 3D biomechanical properties of the ankle complex. One such computational model was introduced by our group in 2004 [1], and this model was partially validated with a very limited set of parameters for comparison. In the current study, we have developed an improvised version of this model and validated it on a subject to subject basis for a number of specimens. This is achieved by comparing a wide range of biomechanical parameters between the experiments and the simulation. Once, the model is validated, it can be used for a wide variety of clinical and surgical applications .Some applications include comparing the effects of surface morphology on the kinematics of the ankle joint, diagnosing and evaluation of ankle disorders like ligament tears and reconstruction surgeries. Previous experimental studies conducted to understand and validate the effect of morphological variations to kinematics involved invasive surgical procedures and hence could only be conducted in cadaveric foot. Hence a need for a dynamic model which could predict and recreate the kinematics of an ankle using only CT and, or MRI data was realized. Such a model could help in development and non-invasive testing of subject specific TAR. This thesis focusses on the subject specific validation of rigid body models of four specimens and an one-to-one validation based on Load-displacement curves, Range of Motion, Surface-to-surface interaction and Ligament straining patterns. Post validation of the MBS model in MSC ADAMS, the model is used to investigate the effect of axial loads, total ankle arthrodesis and the effect of varying surface morphologies on the behavior of the ankle joint complex. An in-depth comparative analysis on the use of a numerical model for the development and performance evaluation of an implant derived from the morphological parameters of the ankle joint is also presented."
      doi = "10.7554/elife.01567"
      subject = described_class.new(input: input, doi: doi)
      # expect(subject.valid?).to be true
      expect(subject.id).to eq("https://doi.org/10.7554/elife.01567")
      expect(subject.titles).to eq([{ "title" => "Validation of an Image-based Subject-Specific Dynamic Model of the Ankle Joint Complex and its Applications to the Study of the Effect of Articular Surface Morphology on Ankle Joint Mechanics" }])
      expect(subject.descriptions.first["description"]).to eq(abs)
    end
  end
end
