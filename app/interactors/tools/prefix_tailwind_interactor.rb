# frozen_string_literal: true

module Tools
  class PrefixTailwindInteractor
    include ApplicationInteractor

    def call
      doc = Nokogiri::HTML::DocumentFragment.parse(context.html)
      doc.css('*').each do |el|
        css_class = el['class']&.split(' ')&.map do |cl|
          if cl.start_with?('-')
            "-tw-#{cl[1..]}"
          elsif cl.include?(':')
            prefix, body = cl.split(':')
            "#{prefix}:tw-#{body}"
          else
            "tw-#{cl}"
          end
        end&.join(' ')

        el['class'] = css_class
      end

      context.object = doc.to_html
    end
  end
end
