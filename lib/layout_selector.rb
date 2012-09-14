module LayoutSelector
  def select_layout
    @layout = "application"
    @layout = "connect" if HostGaymerconnectConstraint.new.matches?(request)
    Rails.logger.debug "LS Selecting layout: #{@layout}"
    @layout
  end
end