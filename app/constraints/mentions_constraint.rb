class MentionsConstraint
  def matches?(request)
    request.host == 'mentions.lvh.me'
  end
end
