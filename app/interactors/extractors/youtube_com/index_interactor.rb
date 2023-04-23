# frozen_string_literal: true

# TODO: Check this later https://www.youtube.com/feeds/videos.xml?channel_id=UCQikj3QCbci5DZbfvdHBGjQ
module Extractors
  module YoutubeCom
    class IndexInteractor
      include ApplicationInteractor
      def call
        uri = Addressable::URI.parse(context.q)

        path = uri.path
        query_values = uri.query_values || {}
        parts = path.split('/')

        context.object = {
          playlist: nil,
          channel: nil,
          video: nil
        }

        ###
        youtu_be = lambda {
          uri.domain == 'youtu.be' && parts.second
        }

        if youtu_be.call
          result = Extractors::YoutubeCom::ListVideosInteractor.call(id: youtu_be.call).object.to_h
          context.object[:video] = result
          channel_id = result.dig(:items, 0, :snippet, :channel_id)
        end

        ###
        watch = lambda {
          parts.second == 'watch' && query_values['v']
        }

        if watch.call
          result = Extractors::YoutubeCom::ListVideosInteractor.call(id: watch.call).object.to_h
          context.object[:video] = result
          channel_id = result.dig(:items, 0, :snippet, :channel_id)
        end

        ###
        playlist = lambda {
          query_values['list']
        }

        if playlist.call
          result = Extractors::YoutubeCom::ListPlaylistsInteractor.call(id: playlist.call).object.to_h
          context.object[:playlist] = result
          channel_id = result.dig(:items, 0, :snippet, :channel_id)
        end

        ###
        user = lambda {
          parts.third if parts.second == 'user'
        }

        if user.call
          result = Extractors::YoutubeCom::ListChannelsInteractor.call(for_username: user.call).object.to_h
          channel_id = result.dig(:items, 0, :id)
        end

        ###
        c = lambda {
          context.q if parts.second == 'c'
        }

        if c.call
          result = Extractors::Metadata::IframelyInteractor.call(url: c.call).object
          canonical = result['meta']['canonical']
          channel_id = Addressable::URI.parse(canonical).path.split('/').third
        end

        ###
        channel = lambda {
          (parts.second == 'channel' && parts.third) || channel_id
        }

        if channel.call
          result = Extractors::YoutubeCom::ListChannelsInteractor.call(id: channel.call).object.to_h
          context.object[:channel] = result
        end
      end
    end
  end
end
