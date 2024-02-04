[![DOI](https://zenodo.org/badge/435411633.svg)](https://zenodo.org/doi/10.5281/zenodo.5785518)
[![Gem Version](https://badge.fury.io/rb/commonmeta-ruby.svg)](https://badge.fury.io/rb/commonmeta-ruby)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=front-matter_commonmeta-ruby&metric=coverage)](https://sonarcloud.io/summary/new_code?id=front-matter_commonmeta-ruby)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=front-matter_commonmeta-ruby&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=front-matter_commonmeta-ruby)
![GitHub](https://img.shields.io/github/license/front-matter/commonmeta-ruby?logo=MIT)

# commonmeta-ruby

Ruby gem and command-line utility for the conversion of scholarly metadata, including [schema.org](https://schema.org). Based on the [bolognese](https://github.com/datacite/bolognese) gem, but using [commonmeta](https://commonmeta.org) as the intermediate format, and supporting additional metadata formats. A Python version is available at [commonmeta-py](https://github.com/front-matter/commonmeta-py).

## Supported Metadata Formats

commonmeta-ruby reads and/or writes these metadata formats:

| Format | Name | Content Type | Read | Write |
| ------ | ---- | ------------ | ---- | ----- |
| [Commonmeta](https://commonmeta.org) | commonmeta | application/vnd.commonmeta+json | yes | yes |
| [CrossRef Unixref XML](https://www.crossref.org/schema/documentation/unixref1.1/unixref1.1.html) | crossref | application/vnd.crossref.unixref+xml | yes | yes |
| [Crossref](https://api.crossref.org) | crossref | application/vnd.crossref+json | yes | no |
| [DataCite](https://api.datacite.org/) | datacite | application/vnd.datacite.datacite+json | yes | yes |
| [Schema.org (in JSON-LD)](http://schema.org/) | schema_org | application/vnd.schemaorg.ld+json | yes | yes |
| [RDF XML](http://www.w3.org/TR/rdf-syntax-grammar/) | rdf_xml | application/rdf+xml | no | yes |
| [RDF Turtle](http://www.w3.org/TeamSubmission/turtle/) | turtle | text/turtle | no | yes |
| [CSL-JSON](https://citationstyles.org/) | csl | application/vnd.citationstyles.csl+json | yes | yes |
| [Formatted text citation](https://citationstyles.org/) | citation | text/x-bibliography | no | yes |
| [Codemeta](https://codemeta.github.io/) | codemeta | application/vnd.codemeta.ld+json | yes | yes |
| [Citation File Format (CFF)](https://citation-file-format.github.io/) | cff | application/vnd.cff+yaml | yes | yes |
| [JATS](https://jats.nlm.nih.gov/) | jats | application/vnd.jats+xml | no | yes |
| [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) | csv | text/csv | no | yes |
| [BibTex](http://en.wikipedia.org/wiki/BibTeX) | bibtex | application/x-bibtex | yes | yes |
| [RIS](http://en.wikipedia.org/wiki/RIS_(file_format)) | ris | application/x-research-info-systems | yes | yes |

## Installation

Requires Ruby 3.0 or later (Ruby 2.x [has reached its end of life](https://endoflife.date/ruby) March 2023). Then add the following to your `Gemfile` to install the
latest version:

```ruby
gem 'commonmeta-ruby'
```

Then run `bundle install` to install into your environment.

You can also install the gem system-wide in the usual way:

```bash
gem install commonmeta-ruby
```

## Commands

Run the `commonmeta` command with either an identifier (DOI or URL) or filename:

```
commonmeta https://doi.org/10.7554/elife.01567
```

```
commonmeta example.xml
```

commonmeta can read BibTeX files (file extension `.bib`), RIS files (file extension `.ris`), Crossref files (file extension `.xml`), DataCite files and CSL-JSON files.

The input format (e.g. Crossref or BibteX) is automatically detected, but
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

Read Crossref XML and write as BibTeX:

```
commonmeta https://doi.org/10.7554/elife.01567 -f crossref_xml -t bibtex

@article{https://doi.org/10.7554/elife.01567,
  doi = {10.7554/elife.01567},
  url = {https://elifesciences.org/articles/01567},
  author = {Sankar, Martial and Nieminen, Kaisa and Ragni, Laura and Xenarios, Ioannis and Hardtke, Christian S},
  title = {Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth},
  journal = {eLife},
  volume = {3},
  pages = {e01567},
  publisher = {eLife Sciences Publications, Ltd},
  year = {2014},
  copyright = {CC-BY-3.0}
}
```

Convert Crossref to schema.org/JSON-LD:

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

Convert Crossref to DataCite:

```sh
commonmeta https://doi.org/10.7554/elife.01567 -t datacite

{
  "id": "https://doi.org/10.7554/elife.01567",
  "doi": "10.7554/elife.01567",
  "url": "https://elifesciences.org/articles/01567",
  "types": {
    "resourceTypeGeneral": "JournalArticle",
    "bibtex": "article",
    "citeproc": "article-journal",
    "ris": "JOUR",
    "schemaOrg": "ScholarlyArticle"
  },
  "creators": [
    {
      "name": "Sankar, Martial",
      "nameType": "Personal",
      "givenName": "Martial",
      "familyName": "Sankar",
      "affiliation": [
        {
          "name": "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland"
        }
      ]
    },
    {
      "name": "Nieminen, Kaisa",
      "nameType": "Personal",
      "givenName": "Kaisa",
      "familyName": "Nieminen",
      "affiliation": [
        {
          "name": "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland"
        }
      ]
    },
    {
      "name": "Ragni, Laura",
      "nameType": "Personal",
      "givenName": "Laura",
      "familyName": "Ragni",
      "affiliation": [
        {
          "name": "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland"
        }
      ]
    },
    {
      "name": "Xenarios, Ioannis",
      "nameType": "Personal",
      "givenName": "Ioannis",
      "familyName": "Xenarios",
      "affiliation": [
        {
          "name": "Vital-IT, Swiss Institute of Bioinformatics, Lausanne, Switzerland"
        }
      ]
    },
    {
      "name": "Hardtke, Christian S",
      "nameType": "Personal",
      "givenName": "Christian S",
      "familyName": "Hardtke",
      "affiliation": [
        {
          "name": "Department of Plant Molecular Biology, University of Lausanne, Lausanne, Switzerland"
        }
      ]
    }
  ],
  "titles": [
    {
      "title": "Automated quantitative histology reveals vascular morphodynamics during Arabidopsis hypocotyl secondary growth"
    }
  ],
  "publisher": "eLife Sciences Publications, Ltd",
  "container": {
    "type": "Journal",
    "title": "eLife",
    "identifier": "2050-084X",
    "identifierType": "ISSN",
    "volume": "3"
  },
  "subjects": [

  ],
  "contributors": [

  ],
  "dates": [
    {
      "date": "2014-02-11",
      "dateType": "Issued"
    },
    {
      "date": "2022-03-26",
      "dateType": "Updated"
    }
  ],
  "alternateIdentifiers": [

  ],
  "rightsList": [
    {
      "rightsIdentifier": "cc-by-3.0",
      "rightsUri": "https://creativecommons.org/licenses/by/3.0/legalcode",
      "rights": "Creative Commons Attribution 3.0 Unported",
      "rightsIdentifierScheme": "SPDX",
      "schemeUri": "https://spdx.org/licenses/"
    }
  ],
  "descriptions": [
    {
      "description": "Among various advantages, their small size makes model organisms preferred subjects of investigation. Yet, even in model systems detailed analysis of numerous developmental processes at cellular level is severely hampered by their scale. For instance, secondary growth of Arabidopsis hypocotyls creates a radial pattern of highly specialized tissues that comprises several thousand cells starting from a few dozen. This dynamic process is difficult to follow because of its scale and because it can only be investigated invasively, precluding comprehensive understanding of the cell proliferation, differentiation, and patterning events involved. To overcome such limitation, we established an automated quantitative histology approach. We acquired hypocotyl cross-sections from tiled high-resolution images and extracted their information content using custom high-throughput image processing and segmentation. Coupled with automated cell type recognition through machine learning, we could establish a cellular resolution atlas that reveals vascular morphodynamics during secondary growth, for example equidistant phloem pole formation.",
      "descriptionType": "Abstract"
    }
  ],
  "fundingReferences": [
    {
      "funderName": "SystemsX"
    },
    {
      "funderName": "EMBO longterm post-doctoral fellowships"
    },
    {
      "funderName": "Marie Heim-Voegtlin"
    },
    {
      "funderName": "University of Lausanne",
      "funderIdentifier": "https://doi.org/10.13039/501100006390",
      "funderIdentifierType": "Crossref Funder ID"
    },
    {
      "funderName": "SystemsX"
    },
    {
      "funderName": "EMBO",
      "funderIdentifier": "https://doi.org/10.13039/501100003043",
      "funderIdentifierType": "Crossref Funder ID"
    },
    {
      "funderName": "Swiss National Science Foundation",
      "funderIdentifier": "https://doi.org/10.13039/501100001711",
      "funderIdentifierType": "Crossref Funder ID"
    },
    {
      "funderName": "University of Lausanne",
      "funderIdentifier": "https://doi.org/10.13039/501100006390",
      "funderIdentifierType": "Crossref Funder ID"
    }
  ],
  "relatedIdentifiers": [
    {
      "relatedIdentifier": "https://doi.org/10.1038/nature02100",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1534/genetics.109.104976",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1034/j.1399-3054.2002.1140413.x",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1162/089976601750399335",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1007/bf00994018",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1242/dev.119.1.71",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/j.semcdb.2009.09.009",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1242/dev.091314",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1371/journal.pgen.1002997",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1038/msb.2010.25",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/j.biosystems.2012.07.004",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/j.pbi.2005.11.013",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1105/tpc.110.076083",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1073/pnas.0808444105",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/0092-8674(89)90900-8",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1126/science.1066609",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1104/pp.104.040212",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1038/nbt1206-1565",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1073/pnas.77.3.1516",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1093/bioinformatics/btq046",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1105/tpc.111.084020",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.5061/dryad.b835k",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/j.cub.2008.02.070",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1111/j.1469-8137.2010.03236.x",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1007/s00138-011-0345-9",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1016/j.cell.2012.02.048",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    },
    {
      "relatedIdentifier": "https://doi.org/10.1038/ncb2764",
      "relatedIdentifierType": "DOI",
      "relationType": "References"
    }
  ],
  "schemaVersion": "http://datacite.org/schema/kernel-4",
  "agency": "Crossref",
  "state": "findable"
}
```

Convert Crossref to BibTeX:

```sh
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



Convert DataCite to schema.org/JSON-LD:

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
