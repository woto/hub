class TelegramBot::SearchEntityParser
  def self.call(text:)
    emoji_key, query = text.split(':', 2)
    {
      emoji_key: emoji_key.to_s.strip,
      query: query.to_s.strip
    }
  end
end
