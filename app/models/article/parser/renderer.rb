# frozen_string_literal: true

class Article
  class Parser
    class Renderer < Redcarpet::Render::HTML
      # def header(title, level)
      #   "<h#{level}>#{title}</h1>"
      # end
      #
      # def doc_header
      #   "<div class='news-article'>"
      # end
      #
      # def doc_footer
      #   "</div>"
      # end

      def image(url, title, alt_text)
        "<img src='/#{@options[:images_path]}/#{url}' title='#{title}' alt='#{alt_text}'>"
      end
    end
  end
end
