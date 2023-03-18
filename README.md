[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5785519.svg)](https://doi.org/10.5281/zenodo.5785519)
[![Gem Version](https://badge.fury.io/rb/commonmeta-ruby.svg)](https://badge.fury.io/rb/commonmeta-ruby)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=front-matter_commonmeta-ruby&metric=coverage)](https://sonarcloud.io/summary/new_code?id=front-matter_commonmeta-ruby)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=front-matter_commonmeta-ruby&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=front-matter_commonmeta-ruby)
![GitHub](https://img.shields.io/github/license/front-matter/commonmeta-ruby?logo=MIT)

# commonmeta-ruby: a Ruby library for conversion of scholarly metadata

Ruby gem and command-line utility for conversion of DOI metadata from and to different metadata formats, including [schema.org](https://schema.org). Based on the [bolognese](https://github.com/datacite/bolognese) gem, but using [commonmeta](https://commonmeta.org) as the intermediate format.

## Supported Metadata Formats

commonmeta-ruby reads and/or writes these metadata formats:

| Format | Name | Content Type | Read | Write |
| ------ | ---- | ------------ | ---- | ----- |
| [CrossRef Unixref XML](https://www.crossref.org/schema/documentation/unixref1.1/unixref1.1.html) | crossref | application/vnd.crossref.unixref+xml | yes | yes |
| [Crossref JSON](https://api.crossref.org) | crossref | application/vnd.crossref+json | yes | no |
| [DataCite](https://api.datacite.org/) | datacite | application/vnd.datacite.datacite+json | yes | yes |
| [Schema.org (in JSON-LD)](http://schema.org/) | schema_org | application/vnd.schemaorg.ld+json | yes | yes |
| [RDF XML](http://www.w3.org/TR/rdf-syntax-grammar/) | rdf_xml | application/rdf+xml | no | yes |
| [RDF Turtle](http://www.w3.org/TeamSubmission/turtle/) | turtle | text/turtle | no | yes |
| [Citeproc JSON](https://citationstyles.org/) | citeproc | pplication/vnd.citationstyles.csl+json | yes | yes |
| [Formatted text citation](https://citationstyles.org/) | citation | text/x-bibliography | no | yes |
| [Codemeta](https://codemeta.github.io/) | codemeta | application/vnd.codemeta.ld+json | yes | yes |
| [Citation File Format (CFF)](https://citation-file-format.github.io/) | cff | application/vnd.cff+yaml | yes | yes |
| [JATS](https://jats.nlm.nih.gov/) | jats | application/vnd.jats+xml | no | yes |
| [CSV](ttps://en.wikipedia.org/wiki/Comma-separated_values) | csv | text/csv | no | yes |
| [BibTex](http://en.wikipedia.org/wiki/BibTeX) | bibtex | application/x-bibtex | yes | yes |
| [RIS](http://en.wikipedia.org/wiki/RIS_(file_format)) | ris | application/x-research-info-systems | yes | yes |

## Installation

Requires Ruby 3.0 or later. Then add the following to your `Gemfile` to install the
latest version:

```ruby
gem 'commonmeta-ruby'
```

Then run `bundle install` to install into your environment.

You can also install the gem system-wide in the usual way:

```bash
gem install commonmeta-ruby
```
```

## Commands

Run the `commonmeta` command with either an identifier (DOI or URL) or filename:

```
commonmeta https://doi.org/10.7554/elife.01567
```

```
commonmeta example.xml
```

commonmeta can read BibTeX files (file extension `.bib`), RIS files (file extension `.ris`), Crossref files (file extension `.xml`), DataCite files and CSL JSON files.

The input format (e.g. Crossref XML or BibteX) is automatically detected, but
you can also provide the format with the `--from` or `-f` flag. The supported
input formats are listed in the table above.

The output format is determined by the `--to` or `-t` flag, and defaults to `schema_org`.

Show all commands with `commonmeta help`:

```
Commands:
  commonmeta                 # convert metadata
  commonmeta --version, -v   # print the version
  commonmeta help [COMMAND]  # Describe available commands or one specific command
```

## Errors

Errors are returned to STDOUT.

All input is validated against the commonmeta JSON schema.

## Examples

Read Crossref XML:

```
commonmeta https://doi.org/10.7554/elife.01567 -t crossref

<?xml version="1.0" encoding="UTF-8"?>
<doi_records>
  <doi_record owner="10.7554" timestamp="2015-08-11 07:35:02">
    <crossref>
      <journal>
        <journal_metadata language="en">
          <full_title>eLife</full_title>
          <issn media_type="electronic">2050-084X</issn>
        </journal_metadata>
        <journal_issue>
          <publication_date media_type="online">
            <month>02</month>
            <day>11</day>
            <year>2014</year>
          </publication_date>
          <journal_volume>
            <volume>3</volume>
          </journal_volume>
        </journal_issue>
        <journal_article publication_type="full_text">
          <titles>
            <title>Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth</title>
          </titles>
          <contributors>
            <person_name contributor_role="author" sequence="first">
              <given_name>Martial</given_name>
              <surname>Sankar</surname>
            </person_name>
            <person_name contributor_role="author" sequence="additional">
              <given_name>Kaisa</given_name>
              <surname>Nieminen</surname>
            </person_name>
            <person_name contributor_role="author" sequence="additional">
              <given_name>Laura</given_name>
              <surname>Ragni</surname>
            </person_name>
            <person_name contributor_role="author" sequence="additional">
              <given_name>Ioannis</given_name>
              <surname>Xenarios</surname>
            </person_name>
            <person_name contributor_role="author" sequence="additional">
              <given_name>Christian S</given_name>
              <surname>Hardtke</surname>
            </person_name>
          </contributors>
          <publication_date media_type="online">
            <month>02</month>
            <day>11</day>
            <year>2014</year>
          </publication_date>
          <publisher_item>
            <identifier id_type="doi">10.7554/eLife.01567</identifier>
          </publisher_item>
          <crossmark>
            <crossmark_version>1</crossmark_version>
            <crossmark_policy>eLifesciences</crossmark_policy>
            <crossmark_domains>
              <crossmark_domain>
                <domain>www.elifesciences.org</domain>
              </crossmark_domain>
            </crossmark_domains>
            <crossmark_domain_exclusive>false</crossmark_domain_exclusive>
            <custom_metadata>
              <assertion name="received" label="Received" group_name="publication_history" group_label="Publication History" order="0">2013-09-20</assertion>
              <assertion name="accepted" label="Accepted" group_name="publication_history" group_label="Publication History" order="1">2013-12-24</assertion>
              <assertion name="published" label="Published" group_name="publication_history" group_label="Publication History" order="2">2014-02-11</assertion>
              <program name="fundref">
                <assertion name="fundgroup">
                  <assertion name="funder_name">SystemsX</assertion>
                </assertion>
                <assertion name="fundgroup">
                  <assertion name="funder_name">
                    EMBO
                    <assertion name="funder_identifier">http://dx.doi.org/10.13039/501100003043</assertion>
                  </assertion>
                </assertion>
                <assertion name="fundgroup">
                  <assertion name="funder_name">
                    Swiss National Science Foundation
                    <assertion name="funder_identifier">http://dx.doi.org/10.13039/501100001711</assertion>
                  </assertion>
                </assertion>
                <assertion name="fundgroup">
                  <assertion name="funder_name">
                    University of Lausanne
                    <assertion name="funder_identifier" provider="crossref">http://dx.doi.org/10.13039/501100006390</assertion>
                  </assertion>
                </assertion>
              </program>
              <program name="AccessIndicators">
                <license_ref applies_to="vor">http://creativecommons.org/licenses/by/3.0/</license_ref>
                <license_ref applies_to="am">http://creativecommons.org/licenses/by/3.0/</license_ref>
                <license_ref applies_to="tdm">http://creativecommons.org/licenses/by/3.0/</license_ref>
              </program>
            </custom_metadata>
          </crossmark>
          <doi_data>
            <doi>10.7554/eLife.01567</doi>
            <resource>http://elifesciences.org/lookup/doi/10.7554/eLife.01567</resource>
          </doi_data>
          <citation_list>
            ...
            <citation key="22">
              <author>Sankar</author>
              <cYear>2014</cYear>
              <doi>10.5061/dryad.b835k</doi>
            </citation>
            ...
          </citation_list>
          <component_list>
           ...
          </component_list>
        </journal_article>
      </journal>
    </crossref>
  </doi_record>
</doi_records>
```

Convert Crossref XML to schema.org/JSON-LD:

```
commonmeta https://doi.org/10.7554/elife.01567

{
    "@context": "http://schema.org",
    "@type": "ScholarlyArticle",
    "@id": "https://doi.org/10.7554/elife.01567",
    "url": "http://elifesciences.org/lookup/doi/10.7554/eLife.01567",
    "additionalType": "JournalArticle",
    "name": "Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth",
    "author": [{
        "@type": "Person",
        "givenName": "Martial",
        "familyName": "Sankar"
    }, {
        "@type": "Person",
        "givenName": "Kaisa",
        "familyName": "Nieminen"
    }, {
        "@type": "Person",
        "givenName": "Laura",
        "familyName": "Ragni"
    }, {
        "@type": "Person",
        "givenName": "Ioannis",
        "familyName": "Xenarios"
    }, {
        "@type": "Person",
        "givenName": "Christian S",
        "familyName": "Hardtke"
    }],
    "license": "http://creativecommons.org/licenses/by/3.0/",
    "datePublished": "2014-02-11",
    "dateModified": "2015-08-11T05:35:02Z",
    "isPartOf": {
        "@type": "Periodical",
        "name": "eLife",
        "issn": "2050-084X"
    },
    "citation": [{
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1038/nature02100",
        "position": "1",
        "datePublished": "2003"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1534/genetics.109.104976",
        "position": "2",
        "datePublished": "2009"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1034/j.1399-3054.2002.1140413.x",
        "position": "3",
        "datePublished": "2002"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1162/089976601750399335",
        "position": "4",
        "datePublished": "2001"
    }, {
        "@type": "CreativeWork",
        "position": "5",
        "datePublished": "1995"
    }, {
        "@type": "CreativeWork",
        "position": "6",
        "datePublished": "1993"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/j.semcdb.2009.09.009",
        "position": "7",
        "datePublished": "2009"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1242/dev.091314",
        "position": "8",
        "datePublished": "2013"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1371/journal.pgen.1002997",
        "position": "9",
        "datePublished": "2012"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1038/msb.2010.25",
        "position": "10",
        "datePublished": "2010"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/j.biosystems.2012.07.004",
        "position": "11",
        "datePublished": "2012"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/j.pbi.2005.11.013",
        "position": "12",
        "datePublished": "2006"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1105/tpc.110.076083",
        "position": "13",
        "datePublished": "2010"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1073/pnas.0808444105",
        "position": "14",
        "datePublished": "2008"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/0092-8674(89)90900-8",
        "position": "15",
        "datePublished": "1989"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1126/science.1066609",
        "position": "16",
        "datePublished": "2002"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1104/pp.104.040212",
        "position": "17",
        "datePublished": "2004"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1038/nbt1206-1565",
        "position": "18",
        "datePublished": "2006"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1073/pnas.77.3.1516",
        "position": "19",
        "datePublished": "1980"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1093/bioinformatics/btq046",
        "position": "20",
        "datePublished": "2010"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1105/tpc.111.084020",
        "position": "21",
        "datePublished": "2011"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.5061/dryad.b835k",
        "position": "22",
        "datePublished": "2014"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/j.cub.2008.02.070",
        "position": "23",
        "datePublished": "2008"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1111/j.1469-8137.2010.03236.x",
        "position": "24",
        "datePublished": "2010"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1007/s00138-011-0345-9",
        "position": "25",
        "datePublished": "2012"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1016/j.cell.2012.02.048",
        "position": "26",
        "datePublished": "2012"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1038/ncb2764",
        "position": "27",
        "datePublished": "2013"
    }],
    "funder": [{
        "@type": "Organization",
        "name": "SystemsX"
    }, {
        "@type": "Organization",
        "@id": "https://doi.org/10.13039/501100003043",
        "name": "EMBO"
    }, {
        "@type": "Organization",
        "@id": "https://doi.org/10.13039/501100001711",
        "name": "Swiss National Science Foundation"
    }, {
        "@type": "Organization",
        "@id": "https://doi.org/10.13039/501100006390",
        "name": "University of Lausanne"
    }],
    "provider": {
        "@type": "Organization",
        "name": "Crossref"
    }
}
```

Convert Crossref XML to DataCite JSON:

```
commonmeta https://doi.org/10.7554/elife.01567 -t datacite

<?xml version="1.0" encoding="UTF-8"?>
<resource xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://datacite.org/schema/kernel-4" xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
  <identifier identifierType="DOI">10.7554/eLife.01567</identifier>
  <creators>
    <creator>
      <creatorName>Sankar, Martial</creatorName>
      <givenName>Martial</givenName>
      <familyName>Sankar</familyName>
    </creator>
    <creator>
      <creatorName>Nieminen, Kaisa</creatorName>
      <givenName>Kaisa</givenName>
      <familyName>Nieminen</familyName>
    </creator>
    <creator>
      <creatorName>Ragni, Laura</creatorName>
      <givenName>Laura</givenName>
      <familyName>Ragni</familyName>
    </creator>
    <creator>
      <creatorName>Xenarios, Ioannis</creatorName>
      <givenName>Ioannis</givenName>
      <familyName>Xenarios</familyName>
    </creator>
    <creator>
      <creatorName>Hardtke, Christian S</creatorName>
      <givenName>Christian S</givenName>
      <familyName>Hardtke</familyName>
    </creator>
  </creators>
  <titles>
    <title>Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth</title>
  </titles>
  <publisher>eLife</publisher>
  <publicationYear>2014</publicationYear>
  <resourceType resourceTypeGeneral="Text">JournalArticle</resourceType>
  <fundingReferences>
    <fundingReference>
      <funderName>SystemsX</funderName>
    </fundingReference>
    <fundingReference>
      <funderName>EMBO</funderName>
      <funderIdentifier funderIdentifierType="Crossref Funder ID">https://doi.org/10.13039/501100003043</funderIdentifier>
    </fundingReference>
    <fundingReference>
      <funderName>Swiss National Science Foundation</funderName>
      <funderIdentifier funderIdentifierType="Crossref Funder ID">https://doi.org/10.13039/501100001711</funderIdentifier>
    </fundingReference>
    <fundingReference>
      <funderName>University of Lausanne</funderName>
      <funderIdentifier funderIdentifierType="Crossref Funder ID">https://doi.org/10.13039/501100006390</funderIdentifier>
    </fundingReference>
  </fundingReferences>
  <dates>
    <date dateType="Issued">2014-02-11</date>
    <date dateType="Updated">2015-08-11T05:35:02Z</date>
  </dates>
  <relatedIdentifiers>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1038/nature02100</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1534/genetics.109.104976</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1034/j.1399-3054.2002.1140413.x</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1162/089976601750399335</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/j.semcdb.2009.09.009</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1242/dev.091314</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1371/journal.pgen.1002997</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1038/msb.2010.25</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/j.biosystems.2012.07.004</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/j.pbi.2005.11.013</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1105/tpc.110.076083</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1073/pnas.0808444105</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/0092-8674(89)90900-8</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1126/science.1066609</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1104/pp.104.040212</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1038/nbt1206-1565</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1073/pnas.77.3.1516</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1093/bioinformatics/btq046</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1105/tpc.111.084020</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.5061/dryad.b835k</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/j.cub.2008.02.070</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1111/j.1469-8137.2010.03236.x</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1007/s00138-011-0345-9</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1016/j.cell.2012.02.048</relatedIdentifier>
    <relatedIdentifier relatedIdentifierType="DOI" relationType="References">https://doi.org/10.1038/ncb2764</relatedIdentifier>
  </relatedIdentifiers>
  <rightsList>
    <rights rightsURI="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 (CC-BY 3.0)</rights>
  </rightsList>
</resource>
```

Convert Crossref XML to BibTeX:

```
commonmeta https://doi.org/10.7554/elife.01567 -t bibtex

@article{https://doi.org/10.7554/elife.01567,
  doi = {10.7554/eLife.01567},
  url = {http://elifesciences.org/lookup/doi/10.7554/eLife.01567},
  author = {Sankar, Martial and Nieminen, Kaisa and Ragni, Laura and Xenarios, Ioannis and Hardtke, Christian S},
  title = {Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth},
  journal = {eLife},
  year = {2014}
}
```



Convert DataCite JSON to schema.org/JSON-LD:

```sh
commonmeta 10.5061/DRYAD.8515

{
    "@context": "http://schema.org",
    "@type": "Dataset",
    "@id": "https://doi.org/10.5061/dryad.8515",
    "additionalType": "DataPackage",
    "name": "Data from: A new malaria agent in African hominids.",
    "alternateName": "Ollomo B, Durand P, Prugnolle F, Douzery EJP, Arnathau C, Nkoghe D, Leroy E, Renaud F (2009) A new malaria agent in African hominids. PLoS Pathogens 5(5): e1000446.",
    "author": [{
        "@type": "Person",
        "givenName": "Benjamin",
        "familyName": "Ollomo"
    }, {
        "@type": "Person",
        "givenName": "Patrick",
        "familyName": "Durand"
    }, {
        "@type": "Person",
        "givenName": "Franck",
        "familyName": "Prugnolle"
    }, {
        "@type": "Person",
        "givenName": "Emmanuel J. P.",
        "familyName": "Douzery"
    }, {
        "@type": "Person",
        "givenName": "Céline",
        "familyName": "Arnathau"
    }, {
        "@type": "Person",
        "givenName": "Dieudonné",
        "familyName": "Nkoghe"
    }, {
        "@type": "Person",
        "givenName": "Eric",
        "familyName": "Leroy"
    }, {
        "@type": "Person",
        "givenName": "François",
        "familyName": "Renaud"
    }],
    "license": "http://creativecommons.org/publicdomain/zero/1.0/",
    "version": "1",
    "keywords": "Phylogeny, Malaria, Parasites, Taxonomy, Mitochondrial genome, Africa, Plasmodium",
    "datePublished": "2011",
    "hasPart": [{
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.5061/dryad.8515/1"
    }, {
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.5061/dryad.8515/2"
    }],
    "citation": [{
        "@type": "CreativeWork",
        "@id": "https://doi.org/10.1371/journal.ppat.1000446"
    }],
    "schemaVersion": "http://datacite.org/schema/kernel-3",
    "publisher": {
        "@type": "Organization",
        "name": "Dryad Digital Repository"
    },
    "provider": {
        "@type": "Organization",
        "name": "DataCite"
    }
}
```

Convert DataCite JSON to Codemeta:

```
commonmeta https://doi.org/10.5063/f1m61h5x -t codemeta

{
   "@context":"https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
   "@type":"SoftwareSourceCode",
   "@id":"https://doi.org/10.5063/f1m61h5x",
   "identifier":"https://doi.org/10.5063/f1m61h5x",
   "title":"dataone: R interface to the DataONE network of data repositories",
   "agents":{
      "@type":"Person",
      "givenName":"Matthew B.",
      "familyName":"Jones"
   },
   "datePublished":"2016",
   "publisher":{
      "@type":"Organization",
      "name":"KNB Data Repository"
   }
}
```

Convert DataCite to BibTeX:

```
commonmeta 10.5061/DRYAD.8515 -t bibtex

@misc{https://doi.org/10.5061/dryad.8515,
  doi = {10.5061/DRYAD.8515},
  author = {Ollomo, Benjamin and Durand, Patrick and Prugnolle, Franck and Douzery, Emmanuel J. P. and Arnathau, Céline and Nkoghe, Dieudonné and Leroy, Eric and Renaud, François},
  keywords = {Phylogeny, Malaria, Parasites, Taxonomy, Mitochondrial genome, Africa, Plasmodium},
  title = {Data from: A new malaria agent in African hominids.},
  publisher = {Dryad Digital Repository},
  year = {2011}
}
```

Convert schema.org/JSON-LD to BibTeX:

```
commonmeta https://blog.datacite.org/eating-your-own-dog-food -t bibtex

@article{https://doi.org/10.5438/4k3m-nyvg,
  doi = {10.5438/4k3m-nyvg},
  url = {https://blog.datacite.org/eating-your-own-dog-food},
  author = {Fenner, Martin},
  keywords = {datacite, doi, metadata, featured},
  title = {Eating your own Dog Food},
  publisher = {DataCite},
  year = {2016}
}
```

Convert Codemeta to schema.org/JSON-LD:

```
commonmeta https://github.com/datacite/maremma

{
  "@context":"http://schema.org",
  "@type":"SoftwareSourceCode",
  "@id":"https://doi.org/10.5438/qeg0-3gm3",
  "url":"https://github.com/datacite/maremma",
  "name":"Maremma: a Ruby library for simplified network calls",
  "author":{
    "@type":"person",
    "@id":"http://orcid.org/0000-0003-0077-4738",
    "name":"Martin Fenner"
  },
  "description":"Simplifies network calls, including json/xml parsing and error handling. Based on Faraday.",
  "keywords":"faraday, excon, net/http",
  "dateCreated":"2015-11-28",
  "datePublished":"2017-02-24",
  "dateModified":"2017-02-24",
  "publisher":{
    "@type":"Organization",
    "name":"DataCite"
  }
}
```

Convert Codemeta to DataCite:

```
commonmeta https://github.com/datacite/maremma -t datacite

<?xml version="1.0" encoding="UTF-8"?>
<resource xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://datacite.org/schema/kernel-4" xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd">
  <identifier identifierType="DOI">10.5438/qeg0-3gm3</identifier>
  <creators>
    <creator>
      <creatorName>Martin Fenner</creatorName>
      <nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">http://orcid.org/0000-0003-0077-4738</nameIdentifier>
    </creator>
  </creators>
  <titles>
    <title>Maremma: a Ruby library for simplified network calls</title>
  </titles>
  <publisher>DataCite</publisher>
  <publicationYear>2017</publicationYear>
  <resourceType resourceTypeGeneral="Software">SoftwareSourceCode</resourceType>
  <subjects>
    <subject>faraday</subject>
    <subject>excon</subject>
    <subject>net/http</subject>
  </subjects>
  <dates>
    <date dateType="Created">2015-11-28</date>
    <date dateType="Issued">2017-02-24</date>
    <date dateType="Updated">2017-02-24</date>
  </dates>
  <descriptions>
    <description descriptionType="Abstract">Simplifies network calls, including json/xml parsing and error handling. Based on Faraday.</description>
  </descriptions>
</resource>
```

## Development

We use rspec for unit testing:

```
bundle exec rspec
```

Follow along via [Github Issues](https://github.com/front-matter/commonmeta-ruby/issues).
Please open an issue if conversion fails or metadata are not properly supported.

### Note on Patches/Pull Requests

- Fork the project
- Write tests for your new feature or a test that reproduces a bug
- Implement your feature or make a bug fix
- Do not mess with Rakefile, version or history
- Commit, push and make a pull request. Bonus points for topical branches.

## License

**commonmeta-ruby** is released under the [MIT License](https://github.com/front-matter/commonmeta-ruby/blob/master/LICENSE.md).
