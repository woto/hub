class CustomRender < Redcarpet::Render::HTML
  def header(title, level)
    "<h#{level} class='ant-typography'> #{title}</h1>"
  end

  def doc_header
    "<div class='ant-typography'>"
  end

  def doc_footer
    "</div>"
  end
end

class Article
  ARTICLES_PATH = Rails.root.join('docs/articles')

  class << self
    def find(article_dir)
      article_path = "#{ARTICLES_PATH}/#{article_dir}"
      objectify_article(article_path)
    end

    def page(page)
      article_paths = Dir["#{ARTICLES_PATH}/*"]

      articles = article_paths.map do |article_path|
        objectify_article(article_path)
      end
      articles.sort_by!(&:created_at)
      articles.reverse!

      articles.define_singleton_method(:per) do |per|
        per = per.to_i
        articles_with_count = self[((page.to_i.nonzero? || 1) - 1) * per, per]
        articles_with_count.define_singleton_method(:total_count) do
          article_paths.count
        end
        articles_with_count
      end
      articles
    end

    def objectify_article(article_dir)
      date, title = article_dir.split('/').last.split('_')
      OpenStruct.new(
        id: "#{date}/#{title}",
        title: title,
        created_at: Date.parse(date),
        preview: markdownify_file(article_dir, 'preview.md'),
        content: markdownify_file(article_dir, 'content.md')
      )
    end

    def markdownify_file(dir, file_name)
      render_options = {}
      renderer = CustomRender.new(render_options)
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(File.read(File.join(dir, file_name)))
    end
  end
end
