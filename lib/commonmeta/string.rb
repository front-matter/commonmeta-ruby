# frozen_string_literal: true

class String
  def my_titleize
    gsub(/\b(['’]?[a-z])/) { ::Regexp.last_match(1).capitalize.to_s }
  end
end
