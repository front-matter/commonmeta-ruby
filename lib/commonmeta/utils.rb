# frozen_string_literal: true

module Commonmeta
  module Utils
    NORMALIZED_LICENSES = {
      "https://creativecommons.org/licenses/by/1.0" => "https://creativecommons.org/licenses/by/1.0/legalcode",
      "https://creativecommons.org/licenses/by/2.0" => "https://creativecommons.org/licenses/by/2.0/legalcode",
      "https://creativecommons.org/licenses/by/2.5" => "https://creativecommons.org/licenses/by/2.5/legalcode",
      "https://creativecommons.org/licenses/by/3.0" => "https://creativecommons.org/licenses/by/3.0/legalcode",
      "https://creativecommons.org/licenses/by/3.0/us" => "https://creativecommons.org/licenses/by/3.0/legalcode",
      "https://creativecommons.org/licenses/by/4.0" => "https://creativecommons.org/licenses/by/4.0/legalcode",
      "https://creativecommons.org/licenses/by-nc/1.0" => "https://creativecommons.org/licenses/by-nc/1.0/legalcode",
      "https://creativecommons.org/licenses/by-nc/2.0" => "https://creativecommons.org/licenses/by-nc/2.0/legalcode",
      "https://creativecommons.org/licenses/by-nc/2.5" => "https://creativecommons.org/licenses/by-nc/2.5/legalcode",
      "https://creativecommons.org/licenses/by-nc/3.0" => "https://creativecommons.org/licenses/by-nc/3.0/legalcode",
      "https://creativecommons.org/licenses/by-nc/4.0" => "https://creativecommons.org/licenses/by-nc/4.0/legalcode",
      "https://creativecommons.org/licenses/by-nd-nc/1.0" => "https://creativecommons.org/licenses/by-nd-nc/1.0/legalcode",
      "https://creativecommons.org/licenses/by-nd-nc/2.0" => "https://creativecommons.org/licenses/by-nd-nc/2.0/legalcode",
      "https://creativecommons.org/licenses/by-nd-nc/2.5" => "https://creativecommons.org/licenses/by-nd-nc/2.5/legalcode",
      "https://creativecommons.org/licenses/by-nd-nc/3.0" => "https://creativecommons.org/licenses/by-nd-nc/3.0/legalcode",
      "https://creativecommons.org/licenses/by-nd-nc/4.0" => "https://creativecommons.org/licenses/by-nd-nc/4.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-sa/1.0" => "https://creativecommons.org/licenses/by-nc-sa/1.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-sa/2.0" => "https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-sa/2.5" => "https://creativecommons.org/licenses/by-nc-sa/2.5/legalcode",
      "https://creativecommons.org/licenses/by-nc-sa/3.0" => "https://creativecommons.org/licenses/by-nc-sa/3.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-sa/4.0" => "https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode",
      "https://creativecommons.org/licenses/by-nd/1.0" => "https://creativecommons.org/licenses/by-nd/1.0/legalcode",
      "https://creativecommons.org/licenses/by-nd/2.0" => "https://creativecommons.org/licenses/by-nd/2.0/legalcode",
      "https://creativecommons.org/licenses/by-nd/2.5" => "https://creativecommons.org/licenses/by-nd/2.5/legalcode",
      "https://creativecommons.org/licenses/by-nd/3.0" => "https://creativecommons.org/licenses/by-nd/3.0/legalcode",
      "https://creativecommons.org/licenses/by-nd/4.0" => "https://creativecommons.org/licenses/by-nd/2.0/legalcode",
      "https://creativecommons.org/licenses/by-sa/1.0" => "https://creativecommons.org/licenses/by-sa/1.0/legalcode",
      "https://creativecommons.org/licenses/by-sa/2.0" => "https://creativecommons.org/licenses/by-sa/2.0/legalcode",
      "https://creativecommons.org/licenses/by-sa/2.5" => "https://creativecommons.org/licenses/by-sa/2.5/legalcode",
      "https://creativecommons.org/licenses/by-sa/3.0" => "https://creativecommons.org/licenses/by-sa/3.0/legalcode",
      "https://creativecommons.org/licenses/by-sa/4.0" => "https://creativecommons.org/licenses/by-sa/4.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-nd/1.0" => "https://creativecommons.org/licenses/by-nc-nd/1.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-nd/2.0" => "https://creativecommons.org/licenses/by-nc-nd/2.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-nd/2.5" => "https://creativecommons.org/licenses/by-nc-nd/2.5/legalcode",
      "https://creativecommons.org/licenses/by-nc-nd/3.0" => "https://creativecommons.org/licenses/by-nc-nd/3.0/legalcode",
      "https://creativecommons.org/licenses/by-nc-nd/4.0" => "https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode",
      "https://creativecommons.org/licenses/publicdomain" => "https://creativecommons.org/licenses/publicdomain/",
      "https://creativecommons.org/publicdomain/zero/1.0" => "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    }

    # source: https://www.bibtex.com/e/entry-types/
    BIB_TO_CM_TRANSLATIONS = {
      "article" => "JournalArticle",
      "book" => "Book",
      "booklet" => "Book",
      "inbook" => "BookChapter",
      "inproceedings" => "ProceedingsArticle",
      "manual" => "Report",
      "mastersthesis" => "Dissertation",
      "misc" => "Other",
      "phdthesis" => "Dissertation",
      "proceedings" => "Proceedings",
      "techreport" => "Report",
      "unpublished" => "Manuscript",
    }

    CM_TO_BIB_TRANSLATIONS = {
      "Article" => "article",
      "Book" => "book",
      "BookChapter" => "inbook",
      "Dissertation" => "phdthesis",
      "JournalArticle" => "article",
      "Manuscript" => "unpublished",
      "Other" => "misc",
      "Proceedings" => "proceedings",
      "ProceedingsArticle" => "inproceedings",
      "Report" => "techreport",
    }

    # source: https://docs.citationstyles.org/en/stable/specification.html?highlight=book#appendix-iii-types
    CSL_TO_CM_TRANSLATIONS = {
      "article" => "Article",
      "article-journal" => "JournalArticle",
      "article-magazine" => "Article",
      "article-newspaper" => "Article",
      "bill" => "LegalDocument",
      "book" => "Book",
      "broadcast" => "Audiovisual",
      "chapter" => "BookChapter",
      "classic" => "Book",
      "collection" => "Collection",
      "dataset" => "Dataset",
      "document" => "Document",
      "entry" => "Entry",
      "entry-dictionary" => "Entry",
      "entry-encyclopedia" => "Entry",
      "event" => "Event",
      "figure" => "Figure",
      "graphic" => "Image",
      "hearing" => "LegalDocument",
      "interview" => "Document",
      "legal_case" => "LegalDocument",
      "legislation" => "LegalDocument",
      "manuscript" => "Manuscript",
      "map" => "Map",
      "motion_picture" => "Audiovisual",
      "musical_score" => "Document",
      "pamphlet" => "Document",
      "paper-conference" => "ProceedingsArticle",
      "patent" => "Patent",
      "performance" => "Performance",
      "periodical" => "Journal",
      "personal_communication" => "PersonalCommunication",
      "post" => "Post",
      "post-weblog" => "Article",
      "regulation" => "LegalDocument",
      "report" => "Report",
      "review" => "Review",
      "review-book" => "Review",
      "software" => "Software",
      "song" => "Audiovisual",
      "speech" => "Speech",
      "standard" => "Standard",
      "thesis" => "Dissertation",
      "treaty" => "LegalDocument",
      "webpage" => "WebPage",
    }

    CM_TO_CSL_TRANSLATIONS = {
      "Article" => "article",
      "JournalArticle" => "article-journal",
      "Book" => "book",
      "BookChapter" => "chapter",
      "Collection" => "collection",
      "Dataset" => "dataset",
      "Document" => "document",
      "Entry" => "entry",
      "Event" => "event",
      "Figure" => "figure",
      "Image" => "graphic",
      "LegalDocument" => "legal_case",
      "Manuscript" => "manuscript",
      "Map" => "map",
      "Audiovisual" => "motion_picture",
      "Patent" => "patent",
      "Performance" => "performance",
      "Journal" => "periodical",
      "PersonalCommunication" => "personal_communication",
      "Post" => "post",
      "Report" => "report",
      "Review" => "review",
      "Software" => "software",
      "Speech" => "speech",
      "Standard" => "standard",
      "Dissertation" => "thesis",
      "WebPage" => "webpage",
    }

    # source: http://api.crossref.org/types
    CR_TO_CM_TRANSLATIONS = {
      "BookChapter" => "BookChapter",
      "BookPart" => "BookPart",
      "BookSection" => "BookSection",
      "BookSeries" => "BookSeries",
      "BookSet" => "BookSet",
      "BookTrack" => "BookTrack",
      "Book" => "Book",
      "Component" => "Component",
      "Database" => "Database",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "EditedBook" => "EditedBook",
      "Grant" => "Grant",
      "JournalArticle" => "JournalArticle",
      "JournalIssue" => "JournalIssue",
      "JournalVolume" => "JournalVolume",
      "Journal" => "Journal",
      "Monograph" => "Book",
      "Other" => "Other",
      "PeerReview" => "PeerReview",
      "PostedContent" => "Article",
      "ProceedingsArticle" => "ProceedingsArticle",
      "ProceedingsSeries" => "ProceedingsSeries",
      "Proceedings" => "Proceedings",
      "ReferenceBook" => "ReferenceBook",
      "ReferenceEntry" => "Entry",
      "ReportComponent" => "ReportComponent",
      "ReportSeries" => "ReportSeries",
      "Report" => "Report",
      "Standard" => "Standard",
    }

    CM_TO_CR_TRANSLATIONS = {
      "Article" => "PostedContent",
      "BookChapter" => "BookChapter",
      "BookSeries" => "BookSeries",
      "Book" => "Book",
      "Component" => "Component",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "Grant" => "Grant",
      "JournalArticle" => "JournalArticle",
      "JournalIssue" => "JournalIssue",
      "JournalVolume" => "JournalVolume",
      "Journal" => "Journal",
      "ProceedingsArticle" => "ProceedingsArticle",
      "ProceedingsSeries" => "ProceedingsSeries",
      "Proceedings" => "Proceedings",
      "ReportComponent" => "ReportComponent",
      "ReportSeries" => "ReportSeries",
      "Report" => "Report",
      "PeerReview" => "PeerReview",
      "Other" => "Other",
    }

    # source: https://github.com/datacite/schema/blob/master/source/meta/kernel-4/include/datacite-resourceType-v4.xsd
    DC_TO_CM_TRANSLATIONS = {
      "Audiovisual" => "Audiovisual",
      "BlogPosting" => "Article",
      "Book" => "Book",
      "BookChapter" => "BookChapter",
      "Collection" => "Collection",
      "ComputationalNotebook" => "ComputationalNotebook",
      "ConferencePaper" => "ProceedingsArticle",
      "ConferenceProceeding" => "Proceedings",
      "DataPaper" => "JournalArticle",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "Event" => "Event",
      "Image" => "Image",
      "InteractiveResource" => "InteractiveResource",
      "Journal" => "Journal",
      "JournalArticle" => "JournalArticle",
      "Model" => "Model",
      "OutputManagementPlan" => "OutputManagementPlan",
      "PeerReview" => "PeerReview",
      "PhysicalObject" => "PhysicalObject",
      "Poster" => "Speech",
      "Preprint" => "Article",
      "Report" => "Report",
      "Service" => "Service",
      "Software" => "Software",
      "Sound" => "Sound",
      "Standard" => "Standard",
      "Text" => "Document",
      "Thesis" => "Dissertation",
      "Workflow" => "Workflow",
      "Other" => "Other",
    }

    CM_TO_DC_TRANSLATIONS = {
      "Article" => "Preprint",
      "Audiovisual" => "Audiovisual",
      "Book" => "Book",
      "BookChapter" => "BookChapter",
      "Collection" => "Collection",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "Document" => "Text",
      "Entry" => "Text",
      "Event" => "Event",
      "Figure" => "Image",
      "Image" => "Image",
      "JournalArticle" => "JournalArticle",
      "LegalDocument" => "Text",
      "Manuscript" => "Text",
      "Map" => "Image",
      "Patent" => "Text",
      "Performance" => "Audiovisual",
      "PersonalCommunication" => "Text",
      "Post" => "Text",
      "ProceedingsArticle" => "ConferencePaper",
      "Proceedings" => "ConferenceProceeding",
      "Report" => "Report",
      "PeerReview" => "PeerReview",
      "Software" => "Software",
      "Sound" => "Sound",
      "Standard" => "Standard",
      "WebPage" => "Text",
    }

    RIS_TO_CM_TRANSLATIONS = {
      "ABST" => "Text",
      "ADVS" => "Text",
      "AGGR" => "Text",
      "ANCIENT" => "Text",
      "ART" => "Text",
      "BILL" => "Text",
      "BLOG" => "Text",
      "BOOK" => "Book",
      "CASE" => "Text",
      "CHAP" => "BookChapter",
      "CHART" => "Text",
      "CLSWK" => "Text",
      "CTLG" => "Collection",
      "COMP" => "Software",
      "DATA" => "Dataset",
      "DBASE" => "Database",
      "DICT" => "Dictionary",
      "EBOOK" => "Book",
      "ECHAP" => "BookChapter",
      "EDBOOK" => "Book",
      "EJOUR" => "JournalArticle",
      "ELEC" => "Text",
      "ENCYC" => "Encyclopedia",
      "EQUA" => "Equation",
      "FIGURE" => "Image",
      "GEN" => "CreativeWork",
      "GOVDOC" => "GovernmentDocument",
      "GRANT" => "Grant",
      "HEAR" => "Hearing",
      "ICOMM" => "Text",
      "INPR" => "Text",
      "JFULL" => "JournalArticle",
      "JOUR" => "JournalArticle",
      "LEGAL" => "LegalRuleOrRegulation",
      "MANSCPT" => "Text",
      "MAP" => "Map",
      "MGZN" => "MagazineArticle",
      "MPCT" => "Audiovisual",
      "MULTI" => "Audiovisual",
      "MUSIC" => "MusicScore",
      "NEWS" => "NewspaperArticle",
      "PAMP" => "Pamphlet",
      "PAT" => "Patent",
      "PCOMM" => "PersonalCommunication",
      "RPRT" => "Report",
      "SER" => "SerialPublication",
      "SLIDE" => "Slide",
      "SOUND" => "SoundRecording",
      "STAND" => "Standard",
      "THES" => "Dissertation",
      "UNBILL" => "UnenactedBill",
      "UNPB" => "UnpublishedWork",
      "VIDEO" => "Audiovisual",
      "WEB" => "WebPage",
    }

    CM_TO_RIS_TRANSLATIONS = {
      "Article" => "JOUR",
      "Audiovisual" => "VIDEO",
      "Book" => "BOOK",
      "BookChapter" => "CHAP",
      "Collection" => "CTLG",
      "Dataset" => "DATA",
      "Dissertation" => "THES",
      "Document" => "GEN",
      "Entry" => "DICT",
      "Event" => "GEN",
      "Figure" => "FIGURE",
      "Image" => "FIGURE",
      "JournalArticle" => "JOUR",
      "LegalDocument" => "GEN",
      "Manuscript" => "GEN",
      "Map" => "MAP",
      "Patent" => "PAT",
      "Performance" => "GEN",
      "PersonalCommunication" => "PCOMM",
      "Post" => "GEN",
      "ProceedingsArticle" => "CPAPER",
      "Proceedings" => "CONF",
      "Report" => "RPRT",
      "Review" => "GEN",
      "Software" => "COMP",
      "Sound" => "SOUND",
      "Standard" => "STAND",
      "WebPage" => "WEB",
    }

    SO_TO_CM_TRANSLATIONS = {
      "Article" => "Article",
      "BlogPosting" => "Article",
      "Book" => "Book",
      "BookChapter" => "BookChapter",
      "CreativeWork" => "Other",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "NewsArticle" => "Article",
      "Legislation" => "LegalDocument",
      "ScholarlyArticle" => "JournalArticle",
      "SoftwareSourceCode" => "Software",
    }

    CM_TO_SO_TRANSLATIONS = {
      "Article" => "Article",
      "Audiovisual" => "CreativeWork",
      "Book" => "Book",
      "BookChapter" => "BookChapter",
      "Collection" => "CreativeWork",
      "Dataset" => "Dataset",
      "Dissertation" => "Dissertation",
      "Document" => "CreativeWork",
      "Entry" => "CreativeWork",
      "Event" => "CreativeWork",
      "Figure" => "CreativeWork",
      "Image" => "CreativeWork",
      "JournalArticle" => "ScholarlyArticle",
      "LegalDocument" => "Legislation",
      "Software" => "SoftwareSourceCode",
    }

    CM_TO_JATS_TRANSLATIONS = {
      "Proceedings" => "working-paper",
      "ReferenceBook" => "book",
      "JournalIssue" => "journal",
      "ProceedingsArticle" => "working-paper",
      "Other" => nil,
      "Dissertation" => nil,
      "Dataset" => "data",
      "Document" => "journal",
      "EditedBook" => "book",
      "JournalArticle" => "journal",
      "Journal" => "journal",
      "Report" => "report",
      "BookSeries" => "book",
      "ReportSeries" => "report",
      "BookTrack" => "book",
      "Standard" => "standard",
      "BookSection" => "chapter",
      "BookPart" => "chapter",
      "Book" => "book",
      "BookChapter" => "chapter",
      "StandardSeries" => "standard",
      "Monograph" => "book",
      "Component" => nil,
      "ReferenceEntry" => nil,
      "JournalVolume" => "journal",
      "BookSet" => "book",
      "Article" => "journal",
      "Software" => "software",
    }

    UNKNOWN_INFORMATION = {
      ":unac" => "temporarily inaccessible",
      ":unal" => "unallowed, suppressed intentionally",
      ":unap" => "not applicable, makes no sense",
      ":unas" => "value unassigned (e.g., Untitled)",
      ":unav" => "value unavailable, possibly unknown",
      ":unkn" => "known to be unknown (e.g., Anonymous, Inconnue)",
      ":none" => "never had a value, never will",
      ":null" => "explicitly and meaningfully empty",
      ":tba" => "to be assigned or announced later",
      ":etal" => "too numerous to list (et alia)",
    }

    def find_from_format(id: nil, string: nil, ext: nil, filename: nil)
      if id.present?
        find_from_format_by_id(id)
      elsif string.present? && ext.present?
        find_from_format_by_ext(string, ext: ext)
      elsif string.present?
        find_from_format_by_string(string)
      elsif filename.present?
        find_from_format_by_filename(filename)
      else
        "datacite"
      end
    end

    def find_from_format_by_id(id)
      id = normalize_id(id)

      if %r{\A(?:(http|https):/(/)?(dx\.)?(doi\.org|handle\.stage\.datacite\.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}.match?(id)
        ra = get_doi_ra(id)
        %w[DataCite Crossref mEDRA KISTI JaLC OP].include?(ra) ? ra.downcase : nil
      elsif %r{\A(?:(http|https):/(/)?orcid\.org/)?(\d{4}-\d{4}-\d{4}-\d{3}[0-9X]+)\z}.match?(id)
        "orcid"
      elsif %r{\A(http|https):/(/)?github\.com/(.+)/package.json\z}.match?(id)
        "npm"
      elsif %r{\A(http|https):/(/)?github\.com/(.+)/codemeta.json\z}.match?(id)
        "codemeta"
      elsif %r{\A(http|https):/(/)?github\.com/(.+)/CITATION.cff\z}.match?(id)
        "cff"
      elsif %r{\A(http|https):/(/)?github\.com/(.+)\z}.match?(id)
        "cff"
      elsif %r{\A(http|https):/(/)?rogue-scholar\.org/api/posts/(.+)\z}.match?(id)
        "json_feed_item"
      else
        "schema_org"
      end
    end

    def find_from_format_by_filename(filename)
      if filename == "package.json"
        "npm"
      elsif filename == "CITATION.cff"
        "cff"
      end
    end

    def find_from_format_by_ext(string, options = {})
      case options[:ext]
      when ".bib"
        "bibtex"
      when ".ris"
        "ris"
      when ".xml", ".json"
        find_from_format_by_string(string)
      end
    end

    def find_from_format_by_string(string)
      begin # try to parse as JSON
        hsh = MultiJson.load(string).to_h
        if hsh.dig("@context") && URI.parse(hsh.dig("@context")).host == "schema.org"
          return "schema_org"
        elsif hsh.dig("schemaVersion").to_s.start_with?("http://datacite.org/schema/kernel")
          return "datacite"
        elsif hsh.dig("source") == "Crossref"
          return "crossref"
        elsif hsh.dig("issued", "date-parts").present?
          return "csl"
        elsif URI.parse(hsh.dig("@context")).to_s == "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld"
          return "codemeta"
        end
      rescue MultiJson::ParseError
      end

      begin # try to parse as XML
        hsh = Hash.from_xml(string)
        return "crossref_xml" if hsh.to_h.dig("crossref_result").present?
      rescue Nokogiri::XML::SyntaxError
      end

      begin # try to parse as YAML
        hsh = YAML.load(string, permitted_classes: [Date])
        return "cff" if hsh.is_a?(Hash) && hsh.fetch("cff-version", nil).present?
      rescue Psych::SyntaxError
      end

      if string.start_with?("TY  - ")
        "ris"
      elsif BibTeX.parse(string).first
        "bibtex"
      end
    end

    def orcid_from_url(url)
      Array(%r{\A:(http|https)://orcid\.org/(.+)}.match(url)).last
    end

    def orcid_as_url(orcid)
      "https://orcid.org/#{orcid}" if orcid.present?
    end

    def validate_orcid(orcid)
      orcid = Array(%r{\A(?:(?:http|https)://(?:(?:www|sandbox)?\.)?orcid\.org/)?(\d{4}[[:space:]-]\d{4}[[:space:]-]\d{4}[[:space:]-]\d{3}[0-9X]+)\z}.match(orcid)).last
      orcid.gsub(/[[:space:]]/, "-") if orcid.present?
    end

    def validate_orcid_scheme(orcid_scheme)
      Array(%r{\A(http|https)://(www\.)?(orcid\.org)}.match(orcid_scheme)).last
    end

    def validate_url(str)
      if %r{\A(?:(http|https)://(dx\.)?doi.org/)?(doi:)?(10\.\d{4,5}/.+)\z}.match?(str)
        "DOI"
      elsif %r{\A(http|https)://}.match?(str)
        "URL"
      elsif /\A(ISSN|eISSN) (\d{4}-\d{3}[0-9X]+)\z/.match?(str)
        "ISSN"
      end
    end

    def parse_attributes(element, options = {})
      content = options[:content] || "__content__"

      if element.is_a?(String) && options[:content].nil?
        CGI.unescapeHTML(element)
      elsif element.is_a?(Hash)
        element.fetch(CGI.unescapeHTML(content), nil)
      elsif element.is_a?(Array)
        a = element.map { |e| e.is_a?(Hash) ? e.fetch(CGI.unescapeHTML(content), nil) : e }.uniq
        a = options[:first] ? a.first : a.unwrap
      end
    end

    def normalize_id(id, options = {})
      return nil unless id.present?

      # check for valid DOI
      doi = normalize_doi(id, options)
      return doi if doi.present?

      # check for valid HTTP uri
      uri = Addressable::URI.parse(id)
      return nil unless uri && uri.host && %w[http https].include?(uri.scheme)

      # clean up URL
      PostRank::URI.clean(id)
    rescue Addressable::URI::InvalidURIError
      nil
    end

    def normalize_url(id, options = {})
      return nil unless id.present?

      # handle info URIs
      return id if id.to_s.start_with?("info")

      # check for valid HTTP uri
      uri = Addressable::URI.parse(id)

      return nil unless uri && uri.host && %w[http https ftp].include?(uri.scheme)

      # optionally turn into https URL
      uri.scheme = "https" if options[:https]

      # clean up URL
      uri.path = PostRank::URI.clean(uri.path)

      uri.to_s
    rescue Addressable::URI::InvalidURIError
      nil
    end

    def normalize_cc_url(id)
      id = normalize_url(id, https: true)
      NORMALIZED_LICENSES.fetch(id, id)
    end

    def normalize_orcid(orcid)
      orcid = validate_orcid(orcid)
      return nil unless orcid.present?

      # turn ORCID ID into URL
      "https://orcid.org/" + Addressable::URI.encode(orcid)
    end

    # pick electronic issn if there are multiple
    # format issn as xxxx-xxxx
    def normalize_issn(input, options = {})
      content = options[:content] || "__content__"

      issn = if input.blank?
          nil
        elsif input.is_a?(String) && options[:content].nil?
          input
        elsif input.is_a?(Hash)
          input.fetch(content, nil)
        elsif input.is_a?(Array)
          a = input.find { |a| a["media_type"] == "electronic" } || input.first
          a.fetch(content, nil)
        end

      case issn.to_s.length
      when 9
        issn
      when 8
        issn[0..3] + "-" + issn[4..7]
      end
    end

    # find Creative Commons or OSI license in licenses array, normalize url and name
    def normalize_licenses(licenses)
      standard_licenses = Array.wrap(licenses).map do |l|
        URI.parse(l["url"])
      end.select { |li| li.host && li.host[/(creativecommons.org|opensource.org)$/] }
      return licenses unless standard_licenses.present?

      # use HTTPS
      uri.scheme = "https"

      # use host name without subdomain
      uri.host = Array(/(creativecommons.org|opensource.org)/.match uri.host).last

      # normalize URLs
      if uri.host == "creativecommons.org"
        uri.path = uri.path.split("/")[0..-2].join("/") if uri.path.split("/").last == "legalcode"
        uri.path << "/" unless uri.path.end_with?("/")
      else
        uri.path = uri.path.gsub(/(-license|\.php|\.html)/, "")
        uri.path = uri.path.sub(/(mit|afl|apl|osl|gpl|ecl)/) { |match| match.upcase }
        uri.path = uri.path.sub(/(artistic|apache)/) { |match| match.titleize }
        uri.path = uri.path.sub(/([^0-9-]+)(-)?([1-9])?(\.)?([0-9])?$/) do
          m = Regexp.last_match
          text = m[1]

          if m[3].present?
            version = [m[3], m[5].presence || "0"].join(".")
            [text, version].join("-")
          else
            text
          end
        end
      end

      uri.to_s
    rescue URI::InvalidURIError
      nil
    end

    def to_datacite(element, options = {})
      a = Array.wrap(element).map do |e|
        e.each_with_object({}) do |(k, v), h|
          h[k.dasherize] = v
        end
      end
      options[:first] ? a.unwrap : a.presence
    end

    def from_datacite(element)
      mapping = { "nameType" => "type", "creatorName" => "name" }

      map_hash_keys(element: element, mapping: mapping)
    end

    def to_schema_org(element)
      mapping = { "type" => "@type", "id" => "@id", "title" => "name" }

      map_hash_keys(element: element, mapping: mapping)
    end

    def to_schema_org_container(element, options = {})
      return nil unless element.is_a?(Hash) || (element.nil? && options[:container_title].present?)

      issn = element["identifier"] if element["identifierType"] == "ISSN"
      id = issn.blank? ? element["identifier"] : nil
      name = options[:container_title] || element["title"]
      type = id || name ? options[:type] || element["type"] : nil

      { "@id" => id, "@type" => type, "name" => name, "issn" => issn }.compact
    end

    def to_schema_org_identifiers(element, _options = {})
      Array.wrap(element).map do |ai|
        {
          "@type" => "PropertyValue",
          "propertyID" => ai["alternateIdentifierType"],
          "value" => ai["alternateIdentifier"],
        }
      end.unwrap
    end

    def to_schema_org_relation(related_identifiers: nil, relation_type: nil)
      return nil unless related_identifiers.present? && relation_type.present?

      relation_type = if relation_type == "References"
          %w[References Cites
             Documents]
        else
          [relation_type]
        end

      Array.wrap(related_identifiers).select do |ri|
        relation_type.include?(ri["relationType"])
      end.map do |r|
        if r["relatedIdentifierType"] == "ISSN" && r["relationType"] == "IsPartOf"
          { "@type" => "Periodical", "issn" => r["relatedIdentifier"] }.compact
        else
          {
            "@id" => normalize_id(r["relatedIdentifier"]),
            "@type" => DC_TO_SO_TRANSLATIONS[r["resourceTypeGeneral"]] || "CreativeWork",
          }.compact
        end
      end.unwrap
    end

    def to_schema_org_funder(funding_references)
      return nil unless funding_references.present?

      Array.wrap(funding_references).map do |fr|
        {
          "@id" => fr["funderIdentifier"],
          "@type" => "Organization",
          "name" => fr["funderName"],
        }.compact
      end.unwrap
    end

    def to_schema_org_citation(reference)
      return nil unless reference.present?

      {
        "@type" => "CreativeWork",
        "@id" => reference["doi"] ? normalize_id(reference["doi"]) : nil,
        "name" => reference["title"],
        "datePublished" => reference["publicationYear"],
      }.compact
    end

    def to_schema_org_spatial_coverage(geo_location)
      return nil unless geo_location.present?

      Array.wrap(geo_location).each_with_object([]) do |gl, sum|
        if gl.fetch("geoLocationPoint", nil)
          sum << {
            "@type" => "Place",
            "geo" => {
              "@type" => "GeoCoordinates",
              "address" => gl["geoLocationPlace"],
              "latitude" => gl.dig("geoLocationPoint", "pointLatitude"),
              "longitude" => gl.dig("geoLocationPoint", "pointLongitude"),
            },
          }.compact
        end

        if gl.fetch("geoLocationBox", nil)
          sum << {
            "@type" => "Place",
            "geo" => {
              "@type" => "GeoShape",
              "address" => gl["geoLocationPlace"],
              "box" => [gl.dig("geoLocationBox", "southBoundLatitude"),
                        gl.dig("geoLocationBox", "westBoundLongitude"),
                        gl.dig("geoLocationBox", "northBoundLatitude"),
                        gl.dig("geoLocationBox", "eastBoundLongitude")].compact.join(" ").presence,
            }.compact,
          }.compact
        end

        if gl.fetch("geoLocationPolygon", nil)
          sum << {
            "@type" => "Place",
            "geo" => {
              "@type" => "GeoShape",
              "address" => gl["geoLocationPlace"],
              "polygon" => Array.wrap(gl.dig("geoLocationPolygon")).map do |glp|
                Array.wrap(glp).map do |glpp|
                  [glpp.dig("polygonPoint", "pointLongitude"),
                   glpp.dig("polygonPoint", "pointLatitude")].compact
                end.compact
              end.compact.presence,
            },
          }
        end

        next unless gl.fetch("geoLocationPlace",
                             nil) && !gl.fetch("geoLocationPoint",
                                               nil) && !gl.fetch("geoLocationBox",
                                                                 nil) && !gl.fetch(
          "geoLocationPolygon", nil
        )

        sum << {
          "@type" => "Place",
          "geo" => {
            "@type" => "GeoCoordinates",
            "address" => gl["geoLocationPlace"],
          },
        }.compact
      end.unwrap
    end

    def from_schema_org(element)
      mapping = { "@type" => "type", "@id" => "id" }

      map_hash_keys(element: element, mapping: mapping)
    end

    def map_hash_keys(element: nil, mapping: nil)
      Array.wrap(element).map do |a|
        a.map { |k, v| [mapping.fetch(k, k), v] }.reduce({}) do |hsh, (k, v)|
          if k == "affiliation" && v.is_a?(Array)
            hsh[k] = v.map do |affiliation|
              if affiliation.is_a?(Hash)
                affiliation.merge("@type" => "Organization")
              else
                affiliation
              end
            end
            hsh
          elsif k == "type" && v.is_a?(String)
            hsh[k] = v.capitalize
            hsh
          elsif v.is_a?(Hash)
            hsh[k] = to_schema_org(v)
            hsh
          else
            hsh[k] = v
            hsh
          end
        end
      end.unwrap
    end

    def to_identifier(identifier)
      {
        "@type" => "PropertyValue",
        "propertyID" => identifier["relatedIdentifierType"],
        "value" => identifier["relatedIdentifier"],
      }
    end

    def from_json_feed(element)
      mapping = { "url" => "id" }

      map_hash_keys(element: element, mapping: mapping)
    end

    def from_csl(element)
      Array.wrap(element).map do |a|
        if a["literal"].present?
          a["type"] = "Organization"
          a["name"] = a["literal"]
        elsif a["name"].present?
          a["type"] = "Organization"
        elsif a["given"].present? || a["family"].present?
          a["type"] = "Person"
        end
        a["givenName"] = a["given"]
        a["familyName"] = a["family"]
        a.except("given", "family", "literal").compact
      end.unwrap
    end

    def to_csl(element)
      Array.wrap(element).map do |a|
        a["family"] = a["familyName"]
        a["given"] = a["givenName"]
        a["literal"] = a["name"] unless a["familyName"].present?
        a.except("nameType", "type", "@type", "id", "@id", "name", "familyName", "givenName",
                 "affiliation", "contributorType").compact
      end.presence
    end

    def to_ris(element)
      Array.wrap(element).map do |a|
        if a["familyName"].present?
          [a["familyName"], a["givenName"]].join(", ")
        else
          a["name"]
        end
      end.unwrap
    end

    def sanitize(text, options = {})
      options[:tags] ||= Set.new(%w[strong em b i code pre sub sup br])
      content = options[:content] || "__content__"
      custom_scrubber = Commonmeta::WhitelistScrubber.new(options)

      if text.is_a?(String)
        # remove excessive internal whitespace with squish
        Loofah.scrub_fragment(text, custom_scrubber).to_s.squish
      elsif text.is_a?(Hash)
        sanitize(text.fetch(content, nil))
      elsif text.is_a?(Array)
        a = text.map { |e| e.is_a?(Hash) ? sanitize(e.fetch(content, nil)) : sanitize(e) }.uniq
        a = options[:first] ? a.first : a.unwrap
      end
    end

    def github_from_url(url)
      return {} unless %r{\Ahttps://github\.com/(.+)(?:/)?(.+)?(?:/tree/)?(.*)\z}.match?(url)

      words = URI.parse(url).path[1..-1].split("/")
      path = words.length > 3 ? words[4...words.length].join("/") : nil

      { owner: words[0], repo: words[1], release: words[3], path: path }.compact
    end

    def github_repo_from_url(url)
      github_from_url(url).fetch(:repo, nil)
    end

    def github_release_from_url(url)
      github_from_url(url).fetch(:release, nil)
    end

    def github_owner_from_url(url)
      github_from_url(url).fetch(:owner, nil)
    end

    def github_as_owner_url(url)
      github_hash = github_from_url(url)
      "https://github.com/#{github_hash[:owner]}" if github_hash[:owner].present?
    end

    def github_as_repo_url(url)
      github_hash = github_from_url(url)
      return unless github_hash[:repo].present?

      "https://github.com/#{github_hash[:owner]}/#{github_hash[:repo]}"
    end

    def github_as_release_url(url)
      github_hash = github_from_url(url)
      return unless github_hash[:release].present?

      "https://github.com/#{github_hash[:owner]}/#{github_hash[:repo]}/tree/#{github_hash[:release]}"
    end

    def github_as_codemeta_url(url)
      github_hash = github_from_url(url)

      if github_hash[:path].to_s.end_with?("codemeta.json")
        "https://raw.githubusercontent.com/#{github_hash[:owner]}/#{github_hash[:repo]}/#{github_hash[:release]}/#{github_hash[:path]}"
      elsif github_hash[:owner].present?
        "https://raw.githubusercontent.com/#{github_hash[:owner]}/#{github_hash[:repo]}/master/codemeta.json"
      end
    end

    def github_as_cff_url(url)
      github_hash = github_from_url(url)

      if github_hash[:path].to_s.end_with?("CITATION.cff")
        "https://raw.githubusercontent.com/#{github_hash[:owner]}/#{github_hash[:repo]}/#{github_hash[:release]}/#{github_hash[:path]}"
      elsif github_hash[:owner].present?
        "https://raw.githubusercontent.com/#{github_hash[:owner]}/#{github_hash[:repo]}/main/CITATION.cff"
      end
    end

    def get_date_parts(iso8601_time)
      return { "date-parts" => [[]] } if iso8601_time.nil?

      year = iso8601_time[0..3].to_i
      month = iso8601_time[5..6].to_i
      day = iso8601_time[8..9].to_i
      { "date-parts" => [[year, month, day].reject { |part| part == 0 }] }
    rescue TypeError
      nil
    end

    def get_date_from_date_parts(date_as_parts)
      date_parts = date_as_parts.fetch("date-parts", []).first
      return nil if date_parts == [nil]

      year = date_parts[0]
      month = date_parts[1]
      day = date_parts[2]
      get_date_from_parts(year, month, day)
    rescue NoMethodError # if date_parts is nil
      nil
    end

    def get_date_from_parts(year, month = nil, day = nil)
      [year.to_s.rjust(4, "0"), month.to_s.rjust(2, "0"), day.to_s.rjust(2, "0")].reject do |part|
        part == "00"
      end.join("-")
    end

    def get_date_parts_from_parts(year, month = nil, day = nil)
      { "date-parts" => [[year.to_i, month.to_i, day.to_i].reject { |part| part == 0 }] }
    end

    def get_iso8601_date(iso8601_time)
      return nil if iso8601_time.nil? || iso8601_time.length < 4

      case iso8601_time.length
      when 4
        iso8601_time[0..3]
      when 7
        iso8601_time[0..6]
      else
        iso8601_time[0..9]
      end
    end

    def get_year_month(iso8601_time)
      return [] if iso8601_time.nil?

      year = iso8601_time[0..3]
      month = iso8601_time[5..6]

      [year.to_i, month.to_i].reject { |part| part == 0 }
    end

    def get_year_month_day(iso8601_time)
      return [] if iso8601_time.nil?

      year = iso8601_time[0..3]
      month = iso8601_time[5..6]
      day = iso8601_time[8..9]

      [year.to_i, month.to_i, day.to_i].reject { |part| part == 0 }
    end

    # parsing of incomplete iso8601 timestamps such as 2015-04 is broken
    # in standard library, so we use the edtf gem
    # return nil if invalid iso8601 timestamp
    def get_datetime_from_iso8601(iso8601_time)
      Date.edtf(iso8601_time).to_time.utc
    rescue StandardError
      nil
    end

    # strip milliseconds if there is a time, as it interferes with edtc parsing
    # keep dates unchanged
    def strip_milliseconds(iso8601_time)
      return iso8601_time.split(" ").first if iso8601_time.to_s.include? " "

      return iso8601_time.split(".").first + "Z" if iso8601_time.to_s.include? "."

      return iso8601_time.split("+").first + "Z" if iso8601_time.to_s.include? "+"

      iso8601_time
    end

    # iso8601 datetime without hyphens and colons, used by Crossref
    # return nil if invalid
    def get_datetime_from_time(time)
      DateTime.strptime(time.to_s, "%Y%m%d%H%M%S").strftime("%Y-%m-%dT%H:%M:%SZ")
    rescue ArgumentError
      nil
    end

    def get_date(dates, date_type)
      dd = Array.wrap(dates).find { |d| d["dateType"] == date_type } || {}
      dd.fetch("date", nil)
    end

    def get_link(links, link_type)
      ll = Array.wrap(links).find { |d| d["rel"] == link_type } || {}
      ll.fetch("href", nil)
    end

    def rogue_scholar_api_url(id, _options = {})
      "https://rogue-scholar.org/api/posts/#{id}"
    end

    # convert commonmeta dates to DataCite format
    def get_dates_from_date(date)
      return nil if date.nil?

      mapping = { "published" => "issued" }

      date = map_hash_keys(element: date, mapping: mapping)

      date.map do |k, v|
        { "date" => v,
          "dateType" => k.capitalize }
      end
    end

    def get_contributor(contributor, contributor_type)
      contributor.select { |c| c["contributorType"] == contributor_type }
    end

    def get_identifier(identifiers, identifier_type)
      id = Array.wrap(identifiers).find { |i| i["identifierType"] == identifier_type } || {}
      id.fetch("identifier", nil)
    end

    def get_identifier_type(identifier_type)
      return nil unless identifier_type.present?

      identifierTypes = {
        "ark" => "ARK",
        "arxiv" => "arXiv",
        "bibcode" => "bibcode",
        "doi" => "DOI",
        "ean13" => "EAN13",
        "eissn" => "EISSN",
        "handle" => "Handle",
        "igsn" => "IGSN",
        "isbn" => "ISBN",
        "issn" => "ISSN",
        "istc" => "ISTC",
        "lissn" => "LISSN",
        "lsid" => "LSID",
        "pmid" => "PMID",
        "purl" => "PURL",
        "upc" => "UPC",
        "url" => "URL",
        "urn" => "URN",
        "md5" => "md5",
        "minid" => "minid",
        "dataguid" => "dataguid",
      }

      identifierTypes[identifier_type.downcase] || identifier_type
    end

    def get_series_information(str)
      return {} unless str.present?

      str = str.split(",").map(&:strip)

      title = str.first
      volume_issue = str.length > 2 ? str[1].rpartition(/\(([^)]+)\)/) : nil
      volume = volume_issue.present? ? volume_issue[0].presence || volume_issue[2].presence : nil
      issue = volume_issue.present? ? volume_issue[1][1...-1].presence : nil
      pages = str.length > 1 ? str.last : nil
      first_page = pages.present? ? pages.split("-").map(&:strip)[0] : nil
      last_page = pages.present? ? pages.split("-").map(&:strip)[1] : nil

      {
        "title" => title,
        "volume" => volume,
        "issue" => issue,
        "firstPage" => first_page,
        "lastPage" => last_page,
      }.compact
    end

    def jsonlint(json)
      return ["No JSON provided"] unless json.present?

      error_array = []
      linter = JsonLint::Linter.new
      linter.send(:check_data, json, error_array)
      error_array
    end

    def name_to_spdx(name)
      spdx = JSON.load(File.read(File.expand_path("../../resources/spdx/licenses.json",
                                                  __dir__))).fetch("licenses")
      license = spdx.find do |l|
        l["name"] == name || l["licenseId"] == name || l["seeAlso"].first == normalize_cc_url(name)
      end

      if license
        { "id" => license["licenseId"], "url" => license["seeAlso"].first }.compact
      else
        { "rights" => name }
      end
    end

    def hsh_to_spdx(hsh)
      spdx = JSON.load(File.read(File.expand_path("../../resources/spdx/licenses.json",
                                                  __dir__))).fetch("licenses")
      hsh["rightsUri"] = hsh.delete("rightsURI") if hsh["rightsUri"].blank?
      license = spdx.find do |l|
        l["licenseId"].casecmp?(hsh["rightsIdentifier"]) || l["seeAlso"].first == normalize_cc_url(hsh["rightsUri"]) || l["name"] == hsh["rights"] || l["seeAlso"].first == normalize_cc_url(hsh["rights"])
      end

      if license
        { "id" => license["licenseId"], "url" => license["seeAlso"].first }.compact
      else
        {
          "id" => hsh["rightsIdentifier"].present? ? hsh["rightsIdentifier"].downcase : nil,
          "url" => hsh["rightsURI"] || hsh["rightsUri"],
        }.compact
      end
    end

    def spdx_to_hsh(hsh)
      return nil unless hsh.present? && hsh.is_a?(Hash)

      spdx = JSON.load(File.read(File.expand_path("../../resources/spdx/licenses.json",
                                                  __dir__))).fetch("licenses")

      license = spdx.find { |l| l["licenseId"].casecmp?(hsh["id"]) }

      if license
        [{
          "rightsIdentifier" => license["licenseId"].downcase,
          "rightsUri" => license["seeAlso"].first,
          "rights" => license["name"],
          "rightsIdentifierScheme" => "SPDX",
          "schemeUri" => "https://spdx.org/licenses/",
        }.compact]
      else
        [{ "rightsIdentifier" => hsh["id"], "rightsURI" => hsh["url"] }.compact]
      end
    end

    def name_to_fos(name)
      # first find subject in Fields of Science (OECD)
      fos = JSON.load(File.read(File.expand_path("../../resources/oecd/fos-mappings.json",
                                                 __dir__))).fetch("fosFields")

      subject = fos.find { |l| l["fosLabel"] == name || "FOS: " + l["fosLabel"] == name }

      if subject
        return [{
                 "subject" => sanitize(name).downcase,
               },
                {
                 "subject" => "FOS: " + subject["fosLabel"],
                 "subjectScheme" => "Fields of Science and Technology (FOS)",
                 "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
               }]
      end

      # if not found, look in Fields of Research (Australian and New Zealand Standard Research Classification)
      # and map to Fields of Science. Add an extra entry for the latter
      fores = JSON.load(File.read(File.expand_path("../../resources/oecd/for-mappings.json",
                                                   __dir__)))
      for_fields = fores.fetch("forFields")
      for_disciplines = fores.fetch("forDisciplines")

      subject = for_fields.find { |l| l["forLabel"] == name } ||
                for_disciplines.find { |l| l["forLabel"] == name }

      if subject
        [{
          "subject" => sanitize(name).downcase,
        },
         {
          "subject" => "FOS: " + subject["fosLabel"],
          "subjectScheme" => "Fields of Science and Technology (FOS)",
          "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
        }]
      else
        [{ "subject" => sanitize(name).downcase }]
      end
    end

    def hsh_to_fos(hsh)
      # first find subject in Fields of Science (OECD)
      fos = JSON.load(File.read(File.expand_path("../../resources/oecd/fos-mappings.json",
                                                 __dir__))).fetch("fosFields")
      subject = fos.find do |l|
        l["fosLabel"] == hsh["__content__"] || "FOS: " + l["fosLabel"] == hsh["__content__"] || l["fosLabel"] == hsh["subject"]
      end

      if subject
        return [{
                 "subject" => sanitize(hsh["__content__"] || hsh["subject"]),
                 "subjectScheme" => hsh["subjectScheme"],
                 "schemeUri" => hsh["schemeURI"] || hsh["schemeUri"],
                 "valueUri" => hsh["valueURI"] || hsh["valueUri"],
                 "classificationCode" => hsh["classificationCode"],
                 "lang" => hsh["lang"],
               }.compact,
                {
                 "subject" => "FOS: " + subject["fosLabel"],
                 "subjectScheme" => "Fields of Science and Technology (FOS)",
                 "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
               }.compact]
      end

      # if not found, look in Fields of Research (Australian and New Zealand Standard Research Classification)
      # and map to Fields of Science. Add an extra entry for the latter
      fores = JSON.load(File.read(File.expand_path("../../resources/oecd/for-mappings.json",
                                                   __dir__)))
      for_fields = fores.fetch("forFields")
      for_disciplines = fores.fetch("forDisciplines")

      # try to extract forId
      if hsh["subjectScheme"] == "FOR"
        for_id = hsh["__content__"].to_s.split(" ").first || hsh["subject"].to_s.split(" ").first
        for_id = for_id.rjust(6, "0")

        subject = for_fields.find { |l| l["forId"] == for_id } ||
                  for_disciplines.find { |l| l["forId"] == for_id[0..3] }
      else
        subject = for_fields.find do |l|
          l["forLabel"] == hsh["__content__"] || l["forLabel"] == hsh["subject"]
        end ||
                  for_disciplines.find do |l|
                    l["forLabel"] == hsh["__content__"] || l["forLabel"] == hsh["subject"]
                  end
      end

      if subject
        [{
          "subject" => sanitize(hsh["__content__"] || hsh["subject"]),
          "subjectScheme" => hsh["subjectScheme"],
          "classificationCode" => hsh["classificationCode"],
          "schemeUri" => hsh["schemeURI"] || hsh["schemeUri"],
          "valueUri" => hsh["valueURI"] || hsh["valueUri"],
          "lang" => hsh["lang"],
        }.compact,
         {
          "subject" => "FOS: " + subject["fosLabel"],
          "subjectScheme" => "Fields of Science and Technology (FOS)",
          "schemeUri" => "http://www.oecd.org/science/inno/38235147.pdf",
        }]
      else
        [{
          "subject" => sanitize(hsh["__content__"] || hsh["subject"]),
          "subjectScheme" => hsh["subjectScheme"],
          "classificationCode" => hsh["classificationCode"],
          "schemeUri" => hsh["schemeURI"] || hsh["schemeUri"],
          "valueUri" => hsh["valueURI"] || hsh["valueUri"],
          "lang" => hsh["lang"],
        }.compact]
      end
    end

    def encode_doi(prefix)
      # DOI suffix is a generated from a random number, encoded in base32
      # suffix has 8 digits plus two checksum digits. With base32 there are
      # 32 possible digits, so 8 digits gives 32^8 possible combinations
      random_int = SecureRandom.random_number(32 ** 7..(32 ** 8) - 1)
      suffix = Base32::URL.encode(random_int, checksum: true)
      str = "#{suffix[0, 5]}-#{suffix[5, 10]}"
      "https://doi.org/#{prefix}/#{str}"
    end

    def decode_doi(doi)
      suffix = doi.split("/", 5).last
      Base32::URL.decode(suffix)
    end

    def encode_container_id
      # suffix has 5 digits plus two checksum digits. With base32 there are
      # 32 possible digits, so 5 digits gives 32^5 possible combinations
      random_int = SecureRandom.random_number(32 ** 4..(32 ** 5) - 1)
      Base32::URL.encode(random_int, checksum: true)
    end

    def decode_container_id(id)
      Base32::URL.decode(id)
    end

    def json_feed_url(id = nil)
      return "https://rogue-scholar.org/api/blogs/#{id}" if id.present?

      "https://rogue-scholar.org/api/posts"
    end
  end
end
