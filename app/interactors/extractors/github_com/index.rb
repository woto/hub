# frozen_string_literal: true

module Extractors
  module GithubCom
    class Index
      include ApplicationInteractor

      def call
        repo = context.label
                 .gsub(/^https:\/\/github.com\//, '')
                 .gsub(/^http:\/\/github.com\//, '')
                 .gsub(/^http:\/\/www.github.com\//, '')
                 .gsub(/^https:\/\/www.github.com\//, '')

        repository = Extractors::GithubCom::Repository.call(repo: repo).object
        readme = Extractors::GithubCom::Readme.call(repo: repo).object
        result = Extractors::GithubCom::Absolutize.call(
          readme_content: readme,
          base_url: "https://github.com/#{repo}/raw/#{repository.fetch(:default_branch)}/"
        ).object

        context.object = { readme: result.to_s }
      end

    end
  end
end