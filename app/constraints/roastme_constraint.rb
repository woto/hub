class RoastmeConstraint
  def matches?(request)
    request.host == '192.168.1.73.nip.io'
  end
end
