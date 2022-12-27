class TelegramBot::TmpClass
  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def get_fragment
    @joint_fragment = TelegramBot::JointFragmentParser.call(joint_fragment_url: @message.text)
    fragment = Fragment::Parser.call(
      fragment_url: @joint_fragment[:url]
    )
    @first_text = fragment.texts.first
    raise 'Не удалось найти текст в ссылке' if @first_text[:text_start].to_s == '#'
  end

  def wrong_command(e)
    @bot.api.send_message(
      chat_id: @message.chat.id,
      text: <<~TEXT.squish
        Упс, похоже вы прислали не то, что мы ожидали.
        "#{e.message}"
        Возможно вам необходимо ознакомиться со справкой
        https://roastme.ru/telegram-bot
      TEXT
    )
  end

  def send_proceed
    emoji_key = TelegramBot::EmojiKey.call(@joint_fragment)

    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: 'Выбрать',
        switch_inline_query_current_chat: "#{emoji_key.raw} : #{@first_text[:text_start]}"
      )
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    @bot.api.send_message(
      chat_id: @message.chat.id,
      text: 'Отлично! Теперь выберите упоминаемый объект.',
      reply_markup: markup
    )
  end

  def run()
    get_fragment
  rescue StandardError => e
    wrong_command(e)
  else
    send_proceed()
  end
end
