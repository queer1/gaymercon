class PagesController < HighVoltage::PagesController
  layout :select_layout
  include LayoutSelector
end
