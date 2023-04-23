# frozen_string_literal: true

module Extractors
  module YoutubeCom
    class ListSearchesInteractor
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call(q:)
        # youtube = ::Google::Apis::YoutubeV3::YouTubeService.new
        # scope = 'https://www.googleapis.com/auth/youtube'
        # youtube.authorization = ::Google::Auth::ServiceAccountCredentials.make_creds(
        #   json_key_io: File.open(Rails.root.join("config/secrets/#{Rails.env}/goodreviews-ru-246d2654c10a.json")),
        #   scope: scope
        # )
        #
        # # TODO: cache
        # youtube.authorization.fetch_access_token!
        #
        # result = youtube.list_searches(
        #   'snippet',
        #   q: q,
        #   # type: 'channel',
        #   # page_token: page_token,
        #   max_results: 10,
        #   # options: {
        #   #   authorization: auth_client
        #   # }
        # ) do |result, err|
        #   Rails.logger.error(result)
        #   Rails.logger.error(err)
        #   raise err if err
        # end
        #
        # result
      end
    end
  end
end
