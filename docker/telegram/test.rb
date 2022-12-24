require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'telegram/bot'
require 'byebug'
require 'active_record'
require 'active_support'

require 'faraday/multipart'
require "httpx/adapters/faraday"

require_relative 'telegram_session'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'hub_development',
  username: 'hub',
  password: 'Vet:orget5',
  host: 'localhost',
  port: 5432
)

logger = Logger.new(STDOUT)

token = '5251009905:AAHXhcvxODSLy-d-TVVvBs4XwGSvpfQmmig'

Faraday.default_adapter = Faraday::Adapter::HTTPX

class TelegramSessionParser
  def self.call(text: )
    uuid, query = text.split(': ')
    {
      uuid: uuid,
      query: query
    }
  end
end

class JointFragmentParser
  def self.call(joint_fragment_url: )
    match = joint_fragment_url.match(/\"(.*)?\"\n (.*)/)
    {
      text: match && match[1],
      url: match && match[2] || joint_fragment_url
    }
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


Telegram::Bot::Client.run(token, logger: logger) do |bot|
  bot.listen do |message|

  p message
  p URI.decode_www_form_component(message.to_s)
  debugger
  p 1

  case message

    when Telegram::Bot::Types::InlineQuery
      debugger

      result = TelegramSessionParser.call(text: message.query)
      begin
        session = TelegramSession.find(result[:uuid])
      rescue StandardError => e
        next
      end

      joint_fragment = JointFragmentParser.call(joint_fragment_url: session.url)
      fragment = FragmentParser.call(fragment_url: joint_fragment[:url]).first

      results = [
        [1, message.query, 'description description description description description description description', 'https://fakeimg.pl/200x100/828282/ae00de/?retina=1'],
        [2, "#{fragment[:text_start]} #{Time.now.to_s}", '', 'https://fakeimg.pl/200x100/282828/eae0d0/?retina=1']
      ].map do |arr|
        Telegram::Bot::Types::InlineQueryResultArticle.new(
          id: arr[0],
          title: arr[1],
          description: arr[2],
          input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(
            parse_mode: '',
            # parse_mode: 'MarkdownV2',
            message_text: %(Объект "#{arr[1]}" успешно привязан к статье по адресу #{fragment[:scheme]}://#{fragment[:host]}#{fragment[:path]}#{fragment[:query]}),
            disable_web_page_preview: true
          ),
          url: '',
          hide_url: true,
          thumb_url: arr[3],
          thumb_width: 200,
          thumb_height: 100,
          reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new
        )
      end

      begin
        bot.api.answer_inline_query(inline_query_id: message.id, results: results)
      rescue => e
        logger.error(e.message)
      end

    when Telegram::Bot::Types::Message
      next if message.via_bot

      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: 'Здравствуйте, рады что вы решили присоединиться к нашему проекту. Если вы не знакомы с нашим ботом, рекомендуем ознакомиться тут https://roastme.ru/telegram Бот готов принимать упоминания.')
      else
        begin
          joint_fragment = JointFragmentParser.call(joint_fragment_url: message.text)
          fragment = FragmentParser.call(
            fragment_url: joint_fragment[:url]
          ).first
          raise 'Fragment start was not found' if fragment[:text_start].to_s == '#'

        rescue StandardError => e
          bot.api.send_message(chat_id: message.chat.id, text: 'Упс, похоже вы прислали не то, что мы ожидали. Возможно вам необходимо ознакомиться со справкой https://roastme.ru/telegram')
        else
          generated_uuid = SecureRandom.uuid
          TelegramSession.create!(
            id: generated_uuid,
            text: joint_fragment[:text],
            url: joint_fragment[:url]
          )
          kb = [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Выбрать',
              switch_inline_query_current_chat: "#{generated_uuid}: #{fragment[:text_start]}"),
          ]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          begin
            bot.api.send_message(chat_id: message.chat.id,
                                 text: 'Отлично! Теперь выберите упоминаемый объект.',
                                 reply_markup: markup)
          rescue => e
            puts e.message
          end
        end
      end
    end
  end
end
