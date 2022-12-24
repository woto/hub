require 'telegram/bot'
require 'byebug'

token = '5251009905:AAHXhcvxODSLy-d-TVVvBs4XwGSvpfQmmig'

class JointFragmentParser
  def self.call(joint_fragment_url: )
    result = joint_fragment_url.match(/\"(.*)?\"\n (.*)/)
    result && !result[2].empty? ? result[2] : joint_fragment_url
  end
end

class FragmentParser
  def self.call(fragment_url: '')
    # str = 'http://foo/#:~:text=This%20domain,examples&text=in%20literature&text=More%20information...'
    uri = URI(fragment_url.to_s)
    text_chunks = "##{uri.fragment}".gsub(/#.*?:~:(.*?)/, '\1').split(/&?text=/).compact.reject(&:empty?)
    text_fragment = /^(?:(.+?)-,)?(?:(.+?))(?:,([^-]+?))?(?:,-(.+?))?$/
    text_chunks.map do |textFragment|
      {
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        query: uri.query,
        prefix: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\1')),
        text_start: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\2')),
        text_end: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\3')),
        suffix: URI.decode_www_form_component(textFragment.gsub(text_fragment, '\4')),
      }
    end
  end
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

  debugger
  p URI.decode_www_form_component(message.to_s)
  # debugger

  case message

    when Telegram::Bot::Types::InlineQuery

      text = begin
        fragment = FragmentParser.call(fragment_url: message.query).first
        raise 'Fragment start was not found' if fragment[:text_start] == '#'

        fragment[:text_start]
      rescue StandardError => e
        debugger
        next
      end

      next if text.empty?

      results = [
        [1, text, 'description description description description description description description', 'https://fakeimg.pl/200x100/828282/ae00de/?retina=1'],
        [2, "#{text} #{Time.now.to_s}", '', 'https://fakeimg.pl/200x100/282828/eae0d0/?retina=1']
      ].map do |arr|
        Telegram::Bot::Types::InlineQueryResultArticle.new(
          id: arr[0],
          title: arr[1],
          description: arr[2],
          input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(
            # parse_mode: 'MarkdownV2',
            # message_text: "*#{arr[1]}* #{arr[2]}"
            message_text: %(Объект "#{arr[1]}" успешно привязан к статье по адресу #{fragment[:scheme]}://#{fragment[:host]}#{fragment[:path]}#{fragment[:query]})

          ),
          thumb_url: arr[3],
          thumb_width: 200,
          thumb_height: 100
        )
      end

      begin
        bot.api.answer_inline_query(inline_query_id: message.id, results: results)
      rescue => e
        puts e.message
      end
    when Telegram::Bot::Types::Message
      next if message.via_bot

      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: 'Здравствуйте, рады что вы решили присоединиться к нашему проекту. Если вы не знакомы с нашим ботом, рекомендуем ознакомиться тут https://roastme.ru/telegram Бот готов принимать упоминания.')
      else
        begin
          joint_fragment = JointFragmentParser.call(joint_fragment_url: message.text)
          fragment = FragmentParser.call(fragment_url: joint_fragment).first
          raise 'Fragment start was not found' if fragment[:text_start].to_s == '#'
        rescue StandardError => e
          bot.api.send_message(chat_id: message.chat.id, text: 'Упс, похоже вы прислали не то, что мы ожидали. Возможно вам необходимо ознакомиться со справкой https://roastme.ru/telegram')
        else
          kb = [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Выбрать', switch_inline_query_current_chat: joint_fragment),
          ]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          begin
            bot.api.send_message(chat_id: message.chat.id, text: 'Отлично! Теперь выберите упоминаемый объект.', reply_markup: markup)
          rescue => e
            puts e.message
          end
        end
      end
    end
  end
end

