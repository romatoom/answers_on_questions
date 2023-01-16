module ApplicationHelper
  ALERT_TYPES = {
    notice: 'secondary',
    alert: 'danger',
    success: 'success',
    warning: 'warning'
  }.freeze

  def flash_block
    flash.map do |key, message|
      ending_alert_class_name = ALERT_TYPES[key.to_sym] || key
      content_tag :div, message, class: "alert alert-#{ending_alert_class_name}" if flash[key]
    end.join.html_safe
  end
end
