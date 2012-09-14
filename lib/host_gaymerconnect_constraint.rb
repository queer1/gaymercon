class HostGaymerconnectConstraint
  def matches?(request)
    request.host =~ /gaymerconnect.com/
  end
end