# frozen_string_literal: true

class FragmentParser
  def self.call(fragment_url: '')
    uri = Addressable::URI.parse(fragment_url.to_s)
    text_chunks = "##{uri.fragment}".gsub(/#.*?:~:(.*?)/, '\1').split(/&?text=/).compact_blank
    text_fragment = /^(?:(.+?)-,)?(?:(.+?))(?:,([^-]+?))?(?:,-(.+?))?$/
    text_chunks.map do |textFragment|
      FragmentStruct.new(
        location_url: "#{uri.scheme}://#{uri.host}#{uri.path}#{uri.query ? "?#{uri.query}" : ''}",
        prefix: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\1')),
        text_start: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\2')),
        text_end: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\3')),
        suffix: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\4'))
      )
    end
  end
end
