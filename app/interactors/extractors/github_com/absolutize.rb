# frozen_string_literal: true

module Extractors
  module GithubCom
    class Absolutize
      include ApplicationInteractor

      def call
        doc = Nokogiri::HTML.fragment(context.readme_content)
        absolutize(doc)
        context.object = doc
      end

      private

      def absolutize(node)
        node.children.each do |child|
          absolutize(child)

          # https://github.com/rack-app/rack-app/raw/master/assets/rack-app-logo.png

          case child.name
          when 'a'
            next if child['href'].blank? || (child['href'].start_with?('mailto:') || child['href'].start_with?('#'))

            link = child['href'].delete_prefix('/')
            child['href'] = URI.join(context.base_url, "#{link}")
          when 'img'
            link = child['src'].delete_prefix('/')
            child['src'] = URI.join(context.base_url, "#{link}")
          end
        end
      end
    end
  end
end
