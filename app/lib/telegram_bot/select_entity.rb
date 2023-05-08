module TelegramBot
  class SelectEntity
    def initialize(bot, message)
      @bot = bot
      @message = message
    end

    def run
      result = TelegramBot::SearchEntityParser.call(text: @message.query)

      # TODO: send response that text doesn't contain emoji, or session not found.
      emoji = Emoji.find_by_unicode(result[:emoji_key])
      return unless emoji

      emoji_hex = emoji.hex_inspect
      redis_value = REDIS.get(emoji_hex)
      return unless redis_value

      session = JSON.parse(redis_value)

      joint_fragment = TelegramBot::JointFragmentParser.call(joint_fragment_url: session['url'])
      fragment = Fragment::Parser.call(fragment_url: joint_fragment[:url])

      query = ThingsSearchQuery.call(
        fragment:,
        search_string: @message.query.split(':', 2)[1].strip,
        link_url: '',
        from: 0,
        size: 20
      ).object

      entities = GlobalHelper.elastic_client.search(query)

      results = entities['hits']['hits'].map do |entity|
        id = entity['_id']
        title = entity['_source']['title']
        description = entity['_source']['intro']
        url = entity['_source']['images'].dig(0, 'images', '200')
        thumb_url = if url
                      File.join(
                        "#{ENV.fetch('TELEGRAM_SCHEMA')}://#{ENV.fetch('TELEGRAM_DOMAIN')}:#{ENV.fetch('TELEGRAM_PORT')}",
                        url
                      )
                    else
                      ''
                    end

        kb = [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Да',
            callback_data: "yes:#{id}",
            url: ''
          ),
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Нет',
            callback_data: 'no',
            url: ''
          )
        ]
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [kb])

        Telegram::Bot::Types::InlineQueryResultArticle.new(
          id:,
          title:,
          description:,
          input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(
            parse_mode: '',
            message_text: %(Всё верно, сохраняем? Объект: "#{title}", статья: #{fragment[:url]}),
            disable_web_page_preview: true
          ),
          url: '',
          hide_url: true,
          thumb_url:,
          thumb_width: 200,
          thumb_height: 200,
          reply_markup: markup
        )
      end

      begin
        @bot.api.answer_inline_query(inline_query_id: @message.id, results:)
      rescue Telegram::Bot::Exceptions::ResponseError => e
        Rails.logger.warn(e.message)
      end
    end
  end
end
