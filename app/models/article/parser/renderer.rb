class Article
  class Parser
    class Renderer < Redcarpet::Render::HTML
      def header(title, level)
        "<h#{level} class='ant-typography'>#{title}</h1>"
      end

      def doc_header
        "<div class='ant-typography'>"
      end

      def doc_footer
        "</div>"
      end

      def image(url, title, alt_text)
        "<img src='#{@options[:images_path]}/#{url}' title='#{title}' alt='#{alt_text}'>"
      end
    end
  end
end
