# frozen_string_literal: true

module Extractors
  module YoutubeCom
    class ListPlaylistsInteractor
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        youtube = ::Google::Apis::YoutubeV3::YouTubeService.new
        scope = 'https://www.googleapis.com/auth/youtube'
        youtube.authorization = ::Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(Rails.root.join("config/secrets/#{Rails.env}/goodreviews-ru-246d2654c10a.json")),
          scope: scope
        )

        # TODO: cache
        youtube.authorization.fetch_access_token!

        context.object = youtube.list_playlists(
          'contentDetails,id,localizations,player,snippet,status',
          id: context.id,
          # type: 'channel',
          # page_token: page_token,
          max_results: 1,
          # options: {
          #   authorization: auth_client
          # }
        ) do |result, err|
          Rails.logger.error(result)
          Rails.logger.error(err)
          raise err if err
        end
      end
    end
  end
end
