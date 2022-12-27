require 'telegram/bot'
# require 'faraday/multipart'
# require "httpx/adapters/faraday"

class TelegramBot

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
          TmpClass4.new(bot, message).run
        when Telegram::Bot::Types::InlineQuery
          TmpClass2.new(bot, message).run
        when Telegram::Bot::Types::Message
          next if message.via_bot

          case message.text
          when '/start'
            TmpClass3.new(bot, message).run
          else
            TmpClass.new(bot, message).run
          end
        end
      end
    end
  end
end
