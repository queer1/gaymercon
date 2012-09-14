class HostGaymerconConstraint
  def matches?(request)
    Rails.env == "development" ? true : (request.host =~ /gaymercon.org/)
  end
end