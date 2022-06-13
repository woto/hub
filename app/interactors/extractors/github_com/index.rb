# frozen_string_literal: true

module Extractors
  module GithubCom
    class Index
      include ApplicationInteractor

      def call
        repository = Extractors::GithubCom::Repository.call(repo: label).object
        readme = Extractors::GithubCom::Readme.call(repo: label).object
        result = Extractors::GithubCom::Absolutize.call(
          readme_content: readme,
          base_url: "https://github.com/#{label}/raw/#{repository.fetch(:default_branch)}/"
        ).object

        context.object = { readme: result.to_s }
      end

      def label
        uri = URI.parse(context.label)

        label = if uri.host && %w[http https].include?(uri.scheme)
                  uri.path[1..]
                else
                  context.label
                end

        label.split('/').compact_blank.join('/')
      end
    end
  end
end
