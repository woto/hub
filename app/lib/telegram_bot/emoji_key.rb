class TelegramBot::EmojiKey
  EMOJI_KEY_TIMEOUT = 86_400

  def self.call(joint_fragment)
    value = {
      text: joint_fragment[:text],
      url: joint_fragment[:url]
    }

    emoji_key = nil

    loop do
      Rails.logger.debug('Picking random emoji for session key')
      emoji_key = Emoji.all.sample
      redo unless REDIS.set(
        emoji_key.hex_inspect, JSON.dump(value), ex: EMOJI_KEY_TIMEOUT, nx: true
      )
      break
    end

    emoji_key
  end
end
