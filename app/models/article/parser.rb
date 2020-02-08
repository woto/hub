class Article
  class Parser
    def initialize(article_path)
      @article_path = article_path
      @id = @article_path.split('/').last(2).join('/')
    end

    def parse
      OpenStruct.new(
        id: @id,
        preview: markdownify('preview.md'),
        content: markdownify('content.md'),
        meta: meta
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
      render_options = { images_path: "/articles/#{@id}" }
      renderer = Renderer.new(render_options)
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(file_content)
    end

    def read_file(file_name)
      File.read(File.join(@article_path, file_name))
    end
  end
end
