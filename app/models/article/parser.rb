# frozen_string_literal: true

class Article
  class Parser
    def initialize(article_path)
      @article_path = article_path
      @date, @title = @article_path.split('/').last(2)
    end

    def parse
      OpenStruct.new(
        preview: markdownify('preview.md'),
        content: markdownify('content.md'),
        meta: meta,
        date: @date,
        title: @title
      )
    end

    private

    def meta
      # rubocop:disable Security/YAMLLoad
      YAML.load(read_file('meta.yml'))
      # rubocop:enable Security/YAMLLoad
    end

    def markdownify(file_name)
      file_content = read_file(file_name)
      render_options = { images_path: "/articles/#{@date}/#{@title}" }
      renderer = Renderer.new(render_options)
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(file_content)
    end

    def read_file(file_name)
      File.read(File.join(@article_path, file_name))
    end
  end
end
