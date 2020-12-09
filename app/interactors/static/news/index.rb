# frozen_string_literal: true

module Static
  module News
    class Index
      include ApplicationInteractor
      NEWS_PATH = Rails.root.join('public/news')

      def call
        Dir.glob("#{NEWS_PATH}/*").each do |year_path|
          Dir.glob("#{year_path}/*").each do |month_path|
            Dir.glob("#{month_path}/*").each do |day_path|
              Dir.glob("#{day_path}/*").each do |slug_path|
                repository = NewsRepository.new
                news = ::News.new(
                  id: slug_path.split('/')[-4..].join('-'),
                  date: Time.zone.parse(day_path.split('/')[-3..].join('-')),
                  content: Content.new(slug_path).content
                )
                repository.save(news)
              end
            end
          end
        end
      end

      class Content
        def initialize(slug_path)
          @slug_path = slug_path
        end

        def content
          Dir.glob("#{@slug_path}/*")
             .reject { |dir| dir.split('/').last == '_meta' }
             .map do |lang_path|
            lang = lang_path.split('/')[-1]
            {
              lang => {
                'preview' => markdownify(lang_path, 'preview.md'),
                'content' => markdownify(lang_path, 'content.md'),
                'title' => meta(lang)['title'],
                'tags' => meta(lang)['tags']
              }
            }
          end.reduce(:merge)
        end

        def meta(lang)
          @meta ||= {}
          @meta[lang] ||= YAML.safe_load(File.read(File.join(@slug_path, '_meta', "#{lang}.yml")))
        end

        def markdownify(lang_path, file_name)
          file_path = File.join(lang_path, file_name)
          images_path = file_path.split('/')[-7..-2].join('/')
          file_content = File.read(file_path)

          render_options = { images_path: images_path }
          renderer = Article::Parser::Renderer.new(render_options)
          markdown = Redcarpet::Markdown.new(renderer)
          markdown.render(file_content)
        end
      end
    end
  end
end
