class WebsiteConstraint
  def matches?(request)
    Current.realm = Realm.find_by(domain: request.host)
  end
end
