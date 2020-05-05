class Article
  ARTICLES_PATH = Rails.root.join('public/articles')

  class << self
    def find(article_dir)
      article_path = "#{ARTICLES_PATH}/#{article_dir}"
      Parser.new(article_path).parse
    end
  end
end
