module ApplicationHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="alert">
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
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
  
  def user_alerts
    return '' unless current_user.present?
    alerts = current_user.alerts.all
    return '' unless alerts.count > 0
    alert_text = "<div class='info'>"
    current_user.alerts.each do |alert|
      alert_text << "#{alert.message} <br />"
      alert.destroy
    end
    alert_text << "</div>"
    alert_text.html_safe
  end
  
end
