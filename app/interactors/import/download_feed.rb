# frozen_string_literal: true

module Import
  class DownloadFeed
    include ApplicationInteractor

    def call
      Rails.logger.info(message: 'Downloading feed with previous known file size',
                        feed_id: context.feed.id,
                        downloaded_file_size: context.feed.downloaded_file_size)
      url = context.feed.url

      conn = Faraday.new do |faraday|
        faraday.response :logger # log requests and responses to $stdout
        faraday.request :json # encode req bodies as JSON
        faraday.request :retry # retry transient failures
        faraday.response :follow_redirects # follow redirects
        faraday.response :json # decode response bodies as JSON
        faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
      end

      File.open(context.feed.file.path, 'wb') do |f|
        file_size = 0

        begin
          conn.get(url) do |req|
            # Set a callback which will receive tuples of chunk Strings
            # and the sum of characters received so far
            req.options.on_data = proc do |chunk, overall_received_bytes|
              f.write(chunk)
              file_size = overall_received_bytes
              Rails.logger.info "Received #{overall_received_bytes} characters"
            end
          end
        rescue Faraday::ConnectionFailed => e
          raise Import::Process::HTTPServerException, e
        rescue Faraday::TimeoutError => e
          raise Import::Process::ReadTimeout, e
        rescue Faraday::BadRequestError => e
          raise Import::Process::BadRequestError, e
        end

        Rails.logger.info(message: 'Downloading complete',
                          feed_id: context.feed.id,
                          downloaded_file_size: file_size)
        context.feed.update!(operation: 'download', downloaded_file_size: file_size)
      end
    end
  end
end
