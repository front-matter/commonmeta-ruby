# frozen_string_literal: true

# modified from http://stackoverflow.com/a/29431089
# preserve attributes in xml

module ActiveSupport
  class XMLConverter
    private

    def become_content?(value)
      value['type'] == 'file' || value['type'] == 'string' || (value['__content__'] && (value.keys.size == 1 && value['__content__'].present?))
    end
  end
end
