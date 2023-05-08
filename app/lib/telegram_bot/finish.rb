module TelegramBot
  class Finish
    def initialize(bot, message)
      @bot = bot
      @message = message
    end

    def run
      @bot.api.edit_message_text(
        text: 'Ok!',
        inline_message_id: @message.inline_message_id
      )
    end
  end
end
