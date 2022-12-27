class TelegramBot::JointFragmentParser
  def self.call(joint_fragment_url:)
    match = joint_fragment_url.match(/"(.*)?"\n (.*)/)
    {
      text: match && match[1],
      url: (match && match[2]) || joint_fragment_url
    }
  end
end
