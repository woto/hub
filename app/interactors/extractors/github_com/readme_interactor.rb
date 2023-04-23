# frozen_string_literal: true

module Extractors
  module GithubCom
    class ReadmeInteractor
      include ApplicationInteractor
      # include Rails.application.routes.url_helpers

      def call
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_KEY'))
        context.object = client.readme(context.repo, accept: 'application/vnd.github.html')
        # context.object = client.readme(context.repo, accept: 'application/vnd.github.v3+json')
        # context.object = client.readme(context.repo, accept: 'application/vnd.github.v3.raw')
      end

    end
  end
end
