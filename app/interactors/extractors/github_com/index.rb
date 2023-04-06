# frozen_string_literal: true

module Extractors
  module GithubCom
    class Index
      include ApplicationInteractor

      class WrongRepoError < StandardError; end

      def call
        repository = Extractors::GithubCom::Repository.call(repo: repo).object
        readme = Extractors::GithubCom::Readme.call(repo: repo).object
        result = Extractors::GithubCom::Absolutize.call(
          readme_content: readme,
          base_url: "https://github.com/#{repo}/raw/#{repository.fetch(:default_branch)}/"
        ).object

        context.object = { readme: result.to_s }
      rescue WrongRepoError
        context.object = { repos: GithubCom::Search.call(q: context.q).object }
      end

      def repo
        begin
          uri = URI.parse(context.q.strip)

          result = if uri.host && %w[http https].include?(uri.scheme)
                     uri.path[1..]
                   else
                     context.q.strip
                   end

          result = result.split('/').compact_blank
        rescue URI::InvalidURIError => e
          raise WrongRepoError
        end

        raise WrongRepoError if result.length != 2

        result.join('/')
      end
    end
  end
end
