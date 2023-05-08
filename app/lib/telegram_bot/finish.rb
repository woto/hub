class TelegramBot::TmpClass4
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
