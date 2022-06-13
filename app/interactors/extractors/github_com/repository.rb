# frozen_string_literal: true

module Extractors
  module GithubCom
    class Repository
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_KEY'))
        context.object = client.repository(context.repo).to_h
      end
    end
  end
end
