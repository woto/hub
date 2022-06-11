# frozen_string_literal: true

module Extractors
  module TMe
    class ChannelOrChatOrBot
      include ApplicationInteractor

      def call
        conn = Faraday.new do |faraday|
          # faraday.response :logger # log requests and responses to $stdout
          faraday.response :follow_redirects # follow redirects
          faraday.response :raise_error # raises an exception if response is a 4xx or 5xx code
          # faraday.request :json # encode req bodies as JSON
          # faraday.response :json # decode response bodies as JSON
        end

        res = begin
          conn.get("https://t.me/#{context.label}")
        rescue Faraday::Error => e
          Rails.logger.error(e)
          fail!(message: e.message)
        end

        doc = Nokogiri::HTML.fragment(res.body)

        tmp = doc.css('.tgme_page_extra').text.strip
        specific_fields = case tmp
                          when /\A@/
                            {
                              kind: 'telegram_bot'
                            }
                          when /online\z/
                            tmp2 = tmp.delete(' ').scan(/\d+/)
                            {
                              kind: 'telegram_chat',
                              members: tmp2.first,
                              online: tmp2.second
                            }
                          when /subscribers\z/
                            tmp2 = tmp.delete(' ').scan(/\d+/)
                            {
                              kind: 'telegram_channel',
                              subscribers: tmp2.first
                            }
                          else
                            {
                              kind: 'telegram_unknown'
                            }
                          end

        title = doc.css('.tgme_page_title span').text
        description = doc.css('.tgme_page_description').text
        image = doc.css('.tgme_page_photo_image').attr('src')&.value

        context.object = {
          **specific_fields,
          label: context.label,
          title: title,
          description: description,
          image: image
        }
      end
    end
  end
end
