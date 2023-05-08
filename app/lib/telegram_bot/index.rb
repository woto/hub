require 'telegram/bot'
# require 'faraday/multipart'
# require "httpx/adapters/faraday"

module TelegramBot
  class Index
    def self.call
      # Rails.logger = Logger.new($stdout)
      Rails.logger.level = :debug
      # Faraday.default_adapter = Faraday::Adapter::HTTPX

      Telegram::Bot::Client.run(ENV.fetch('TELEGRAM_BOT_TOKEN'), logger: Rails.logger) do |bot|
        bot.listen do |message|
          # Rails.logger.debug(message)
          # debugger

          case message

          when Telegram::Bot::Types::CallbackQuery
            Finish.new(bot, message).run
          when Telegram::Bot::Types::InlineQuery
            SelectEntity.new(bot, message).run
          when Telegram::Bot::Types::Message
            next if message.via_bot

            case message.text
            when '/start'
              Greeting.new(bot, message).run
            else
              ProcessLink.new(bot, message).run
            end
          end
        end
      end
    end
  end
end
