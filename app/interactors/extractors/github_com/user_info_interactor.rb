# frozen_string_literal: true

module Extractors
  module GithubCom
    class UserInfoInteractor
      include ApplicationInteractor

      def call
        client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_KEY'))
        context.object = client.user(context.user).to_h
      end
    end
  end
end
