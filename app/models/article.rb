class Article
  ARTICLES_PATH = Rails.root.join('docs/articles/*')

  class << self
    def page(page)
      article_dirs = Dir[ARTICLES_PATH]

      articles = article_dirs.map do |article_dir|
        OpenStruct.new(
          id: nil,
          created_at: Date.parse(article_dir.split('/').last.split('_').first),
          preview: markdownify_file(article_dir, 'preview.md'),
          content: markdownify_file(article_dir, 'content.md')
        )
      end
      articles.sort_by!(&:created_at)
      articles.reverse!

      articles.define_singleton_method(:per) do |per|
        per = per.to_i
        articles_with_count = self[((page.to_i.nonzero? || 1) - 1) * per, per]
        articles_with_count.define_singleton_method(:total_count) do
          article_dirs.count
        end
        articles_with_count
      end
      articles
    end

    def markdownify_file(dir, file_name)
      Kramdown::Document.new(File.read(File.join(dir, file_name))).to_html
    end
  end
end
