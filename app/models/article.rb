class Article
  ARTICLES_PATH = Rails.root.join('public/articles')

  class << self
    def find(article_dir)
      article_path = "#{ARTICLES_PATH}/#{article_dir}"
      Parser.new(article_path).parse
    end

    def page(page)
      article_paths = Dir["#{ARTICLES_PATH}/*/*"]

      articles = article_paths.map do |article_path|
        Parser.new(article_path).parse
      end
      articles.sort_by! { |a| a[:meta][:date] }
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
  end
end
