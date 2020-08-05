# frozen_string_literal: true

class Feeds::Download
  include ApplicationInteractor

  def call
    url = context.feed.url
    uri = URI(url)
    req = Net::HTTP::Get.new(uri.request_uri)
    path = context.feed.file_full_path

    File.open(path, 'wb') do |f|
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req) do |response|
          response.value # raise error when response is not successful
          response.read_body { |chunk| f.write(chunk) }
        end
      rescue Net::HTTPServerException => e
        # TODO: mark feed as wrong?
        raise Feeds::Process::FeedDisabledError, e
      rescue Net::ReadTimeout => e
        raise Feeds::Process::TimeoutError, e
      end
    end
  end
end
