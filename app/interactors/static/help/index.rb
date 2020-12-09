# frozen_string_literal: true

module Static
  module Help
    class Index
      include ApplicationInteractor
      HELP_PATH = Rails.root.join('public/help')

      def call
        Dir.glob("#{HELP_PATH}/*").each do |category_path|
          Dir.glob("#{category_path}/*")
             .reject { |dir| dir.split('/').last == '_meta' }
             .each do |slug_path|
            repository = HelpRepository.new
            debugger
            help = ::Help.new(
              id: slug_path.split('/')[-2..].join('/'),
              content: Content.new(slug_path).content
            )
            repository.save(help)
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
                'content' => markdownify(lang_path, 'content.md'),
                'title' => meta(lang)['title'],
                'category' => category(lang)['title']
              }
            }
          end.reduce(:merge)
        end

        def meta(lang)
          @meta ||= {}
          @meta[lang] ||= YAML.safe_load(File.read(File.join(@slug_path, '_meta', "#{lang}.yml")))
        end

        def category(lang)
          @category ||= {}
          @category[lang] ||= YAML.safe_load(File.read(File.join(@slug_path.split('/')[0..-2].join('/'), '_meta', "#{lang}.yml")))
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
