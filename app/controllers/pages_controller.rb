class PagesController < HighVoltage::PagesController
  before_filter do
    @section_name = "GaymerConnect"
    @header_img = "main-header.png"
  end
end
