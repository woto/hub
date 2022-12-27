class TelegramBot::TmpClass3
  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def run
    @bot.api.send_message(
      chat_id: @message.chat.id,
      text: <<~TEXT.squish
        Здравствуйте, рады что вы решили присоединиться к нашему проекту.
        Если вы не знакомы с нашим ботом, рекомендуем ознакомиться тут
        https://roastme.ru/telegram-bot Бот готов принимать упоминания.
      TEXT
    )
  end
end
