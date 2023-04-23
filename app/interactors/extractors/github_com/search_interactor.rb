# frozen_string_literal: true

module Extractors
  module GithubCom
    class SearchInteractor
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_KEY'))
        context.object = client.search_repositories(context.q).to_h
      end
    end
  end
end
