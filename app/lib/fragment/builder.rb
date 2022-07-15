# frozen_string_literal: true

module Fragment
  class Builder
    def self.call(url:, text_start: nil, prefix: nil, suffix: nil, text_end: nil)
      result = url

      fragments = ''
      begin
        fragments += "#{Addressable::URI.escape(prefix)}-," if prefix.present?
        fragments += Addressable::URI.escape(text_start) if text_start.present?
        fragments += ",#{Addressable::URI.escape(text_end)}" if text_end.present?
        fragments += ",-#{Addressable::URI.escape(suffix)}" if suffix.present?
      rescue StandardError
        # Ignored
      end

      if fragments.present?
        result += '#:~:text='
        result += fragments
      end

      result
    end
  end
end
