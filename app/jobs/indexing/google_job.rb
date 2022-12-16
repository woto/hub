# frozen_string_literal: true

# require 'googleauth' # https://github.com/googleapis/google-auth-library-ruby

module Indexing
  class GoogleJob < ApplicationJob
    include Rails.application.routes.url_helpers
    unique :until_executed, on_conflict: :log

    def perform(url:)
      indexing = ::Google::Apis::IndexingV3::IndexingService.new
      scope = 'https://www.googleapis.com/auth/indexing'
      indexing.authorization = ::Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(Rails.root.join("config/secrets/#{Rails.env}/goodreviews-ru-246d2654c10a.json")),
        scope: scope
      )

      # TODO: cache
      indexing.authorization.fetch_access_token!

      url_notification = ::Google::Apis::IndexingV3::UrlNotification.new(
        url: url,
        type: 'URL_UPDATED'
      )

      result = indexing.publish_url_notification(url_notification) do |result, err|
        Rails.logger.error(result)
        Rails.logger.error(err)
        raise err if err
      end
    end
  end
end
