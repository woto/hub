# frozen_string_literal: true

module Fragment
  class Parser
    def self.call(fragment_url: '')
      uri = Addressable::URI.parse(fragment_url.to_s)
      chunks = "##{uri.fragment}".gsub(/#.*?:~:(.*?)/, '\1').split(/&?text=/).compact_blank
      regexp = /^(?:(.+?)-,)?(?:(.+?))(?:,([^-]+?))?(?:,-(.+?))?$/
      Fragment::Struct.new(
        {
          url: "#{uri.scheme}://#{uri.host}#{uri.path}#{uri.query ? "?#{uri.query}" : ''}",
          texts: chunks.map do |chunk|
                   Fragment::Text.new(
                     prefix: URI.decode_www_form_component(chunk.gsub(regexp, '\1')),
                     text_start: URI.decode_www_form_component(chunk.gsub(regexp, '\2')),
                     text_end: URI.decode_www_form_component(chunk.gsub(regexp, '\3')),
                     suffix: URI.decode_www_form_component(chunk.gsub(regexp, '\4'))
                   )
                 end
        }
      )
    end
  end
end
