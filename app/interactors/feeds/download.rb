# frozen_string_literal: true

module Feeds
  class Download
    include ApplicationInteractor

    def call
      Rails.logger.info(message: 'Downloading feed with previous known file size',
                        feed_id: context.feed.id,
                        downloaded_file_size: context.feed.downloaded_file_size)
      url = context.feed.url
      uri = URI(url)
      req = Net::HTTP::Get.new(uri.request_uri)

      File.open(context.feed.file.path, 'wb') do |f|
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          file_size = 0

          http.request(req) do |response|
            response.value # raise error when response is not successful
            response.read_body do |chunk|
              f.write(chunk)
              file_size += chunk.size
            end
          end

          Rails.logger.info(message: 'Downloading complete',
                            feed_id: context.feed.id,
                            downloaded_file_size: file_size)
          context.feed.update!(operation: 'downloaded_file_size', downloaded_file_size: file_size)

        rescue Net::HTTPServerException => e
          raise Feeds::Process::HTTPServerException, e
        rescue Net::ReadTimeout => e
          raise Feeds::Process::ReadTimeout, e
        end
      end
    end
  end
end
