module ApplicationHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="alert clearfix">
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  def header_image
    if @header_img
      return asset_path(@header_img)
    elsif @group
      return @group.header.url(:large) if @group.header.present?
      return asset_path(@group.default_header)
    elsif current_user.present? && current_user.header.present?
      return current_user.header.url(:large)
    end
    return asset_path("main-header.png")
  end
  
  def section_name
    return @section_name if @section_name.present?
    return "GaymerConnect"
  end
  
  def bootstrap_paginate(pages, options={})
    options.reverse_merge!(
      :class => 'pagination', 
      :renderer => BootstrapLinkRenderer, 
      :previous_label => '&lt;&lt;'.html_safe, 
      :next_label => '&gt;&gt;'.html_safe
    )
    will_paginate(pages, options)
  end
  
  def likes(obj)
    likes = obj.likes.count
    return '' unless likes > 0
    noun = likes > 1 ? "people" : "person"
    like_links = obj.likes.collect { |l|
      next unless l.user.present? 
      link_to(l.user.name, user_path(l.user)) 
    }.join(", ").gsub(/\"/, "'")
    # error in bootstrap causes href to continue normally after popover appears :/
    link_to "#{likes} #{noun} rewarded this", 'javascript:void(0);', rel: "popover", data: {html: true, placement: 'top', title: "#{likes} #{noun} rewarded this", content: like_links }
  end
  
  def gridify(collection, partial, opts = {})
    return "" unless collection.present?
    rows = []
    coll_copy = collection.dup
    cols = opts[:cols] || 3
    begin
      row = []
      cols.times { row << coll_copy.shift }
      row.compact!
      rows << row
    end while coll_copy.present?
    
    width = opts[:col_width] || 3
    output = ""
    row_count = 0
    rows.each do |row|
      output << "<div class='row-fluid #{opts[:row_class]} #{(opts[:stripes] && row_count % 2 == 1) ? 'highlight' : ''}'>\n"
      row.each do |col|
        output << "<div class='span#{width} #{opts[:col_class]}'>\n"
        output << render({partial: partial, object: col}.merge(opts))
        output << "\n</div>"
      end
      row_count += 1
      output << "\n</div>"
    end
    
    output.html_safe
  end
  
  def user_alerts
    return '' unless current_user.present?
    alerts = current_user.alerts.all
    return '' unless alerts.count > 0
    alert_text = "<div class=\"row\"><div class=\"span12\"><div class='alert alert-info'>"
    current_user.alerts.each do |alert|
      alert_text << "#{alert.message} <br />"
      alert.destroy
    end
    alert_text << "</div></div></div>"
    alert_text.html_safe
  end
  
  # improved version of https://gist.github.com/1160287
  def wrap(str, opts = {})
    opts = opts.with_indifferent_access
    max_len = opts[:max_length] || 20
    seperator = opts[:seperator] || "<wbr>"
    return str unless str.length > max_len
    ret = ""
    begin
      idx = str.index(seperator)
      if idx.nil? || idx > max_len
        ret += str[0..max_len]
        str = str[(max_len + 1)..-1]
      else
        ret += str[0..idx]
        str = str[(idx + 1)..-1]
      end
      ret << seperator
    end while str.present?

    ret.html_safe
  end
  
  def format_distance(dist)
    return nil if dist.nan?
    return nil if dist > 300
    return "walking distance" if dist < 2
    return "#{dist.to_i} miles away"
  end
  
  # 'cause this function name is too verbose
  def strfnum(num, p = 0, opts = {})
    opts = {precision: p, :delimiter => ','}.merge(opts)
    number_with_precision(num, opts)
  end
  
end
