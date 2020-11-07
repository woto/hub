# frozen_string_literal: true

class Feeds::Download
  include ApplicationInteractor

  def call
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

        context.feed.update!(operation: 'downloaded_file_size', downloaded_file_size: file_size)

      rescue Net::HTTPServerException => e
        # TODO: mark feed as wrong?
        raise Feeds::Process::FeedDisabledError, e
      rescue  Errno::ETIMEDOUT => e
        debugger
        p 1
        raise Feeds::Process::FeedDisabledError, e
      rescue Net::ReadTimeout => e
        raise Feeds::Process::TimeoutError, e
      end
    end
  end
end
